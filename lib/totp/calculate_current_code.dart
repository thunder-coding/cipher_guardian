import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'impl.dart';

/// Calculates TOTP or HOTP code based on the provided parameters
int calculateCurrentCode({
  required String secret,
  required int period,
  required int counter,
  required TOTPAlgorithm algorithm,
  required TOTPType type,
  required int length,
}) {
  // Decode the secret from base32
  final Uint8List keyBytes = _base32Decode(secret);

  // Determine the counter value based on type
  int counterValue;
  if (type == TOTPType.totp) {
    // For TOTP, calculate counter based on current time
    final int unixTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    counterValue = unixTime ~/ period;
  } else /* if (type == TOTPType.hotp) */ {
    // For HOTP, use the provided counter directly
    counterValue = counter;
  }

  // Convert counter to bytes (8-byte big-endian)
  final Uint8List counterBytes = _intToBytes(counterValue);

  // Calculate HMAC using the specified algorithm
  final Uint8List hmacResult = _calculateHmac(
    keyBytes,
    counterBytes,
    algorithm,
  );

  // Dynamic truncation as specified in RFC 4226
  final int truncatedHash = _dynamicTruncate(hmacResult);

  // Return the code with the specified length
  return truncatedHash % _pow10(length);
}

/// Helper function to calculate 10^n as an integer
int _pow10(int n) {
  int result = 1;
  for (int i = 0; i < n; i++) {
    result *= 10;
  }
  return result;
}

/// Decodes a Base32 string to a byte array
Uint8List _base32Decode(String input) {
  // Normalize input: remove spaces and convert to uppercase
  input = input.replaceAll(' ', '').toUpperCase();

  // Base32 alphabet (RFC 4648)
  const String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

  // Remove padding if any
  input = input.replaceAll('=', '');

  // Calculate output length
  final int outputLength = (input.length * 5) ~/ 8;
  final Uint8List result = Uint8List(outputLength);

  int buffer = 0;
  int bitsInBuffer = 0;
  int resultIndex = 0;

  for (int i = 0; i < input.length; i++) {
    final int val = alphabet.indexOf(input[i]);
    if (val == -1) continue; // Skip invalid characters

    // Add 5 bits to the buffer
    buffer = (buffer << 5) | val;
    bitsInBuffer += 5;

    // If we have at least 8 bits, take the most significant 8 and add to result
    if (bitsInBuffer >= 8) {
      bitsInBuffer -= 8;
      result[resultIndex++] = (buffer >> bitsInBuffer) & 0xFF;
    }
  }

  return result;
}

/// Converts an integer to an 8-byte big-endian byte array
Uint8List _intToBytes(int value) {
  final ByteData data = ByteData(8);
  data.setInt64(0, value, Endian.big);
  return data.buffer.asUint8List();
}

/// Calculates an HMAC using the specified algorithm
Uint8List _calculateHmac(
  Uint8List key,
  Uint8List message,
  TOTPAlgorithm algorithm,
) {
  Hash hashAlgorithm;

  switch (algorithm) {
    case TOTPAlgorithm.sha1:
      hashAlgorithm = sha1;
      break;
    case TOTPAlgorithm.sha256:
      hashAlgorithm = sha256;
      break;
    case TOTPAlgorithm.sha512:
      hashAlgorithm = sha512;
      break;
  }

  final hmac = Hmac(hashAlgorithm, key);
  return Uint8List.fromList(hmac.convert(message).bytes);
}

/// Performs dynamic truncation as specified in RFC 4226
int _dynamicTruncate(Uint8List hmacResult) {
  // Get the offset from the last nibble of the last byte
  final int offset = hmacResult[hmacResult.length - 1] & 0x0f;

  // Extract a 31-bit integer (ignore the most significant bit)
  return ((hmacResult[offset] & 0x7f) << 24) |
      ((hmacResult[offset + 1] & 0xff) << 16) |
      ((hmacResult[offset + 2] & 0xff) << 8) |
      (hmacResult[offset + 3] & 0xff);
}
