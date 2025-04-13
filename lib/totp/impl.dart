enum TOTPAlgorithm { sha1, sha256, sha512 }

enum TOTPType { totp, hotp }

extension TOTPAlgorithmExtension on TOTPAlgorithm {
  String get name {
    switch (this) {
      case TOTPAlgorithm.sha1:
        return 'SHA-1';
      case TOTPAlgorithm.sha256:
        return 'SHA-256';
      case TOTPAlgorithm.sha512:
        return 'SHA-512';
    }
  }
}

extension TOTPTypeExtension on TOTPType {
  String get name {
    switch (this) {
      case TOTPType.totp:
        return 'TOTP';
      case TOTPType.hotp:
        return 'HOTP';
    }
  }
}
