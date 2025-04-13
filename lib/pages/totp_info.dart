import 'package:cipher_guardian/totp/impl.dart';
import 'package:flutter/material.dart';

class TotpInfo extends StatefulWidget {
  final Function handler;
  const TotpInfo({super.key, required this.handler});

  @override
  State<TotpInfo> createState() => _TotpInfoState(handler: handler);
}

class _TotpInfoState extends State<TotpInfo> {
  final Function handler;

  final _formKey = GlobalKey<FormState>();
  final _domainController = TextEditingController();
  final _usernameController = TextEditingController();
  final _secretController = TextEditingController();
  final _countController = TextEditingController();
  final _digitsKey = GlobalKey<FormFieldState>();
  final _periodKey = GlobalKey<FormFieldState>();
  final _countKey = GlobalKey<FormFieldState>();
  TOTPType _type = TOTPType.totp;
  final _digitsController = TextEditingController();
  final _periodController = TextEditingController();
  final _domainKey = GlobalKey<FormFieldState>();
  final _usernameKey = GlobalKey<FormFieldState>();
  final _secretKey = GlobalKey<FormFieldState>();
  TOTPAlgorithm algorithm = TOTPAlgorithm.sha1;

  @override
  void initState() {
    super.initState();
    _countController.text = '0';
  }

  _TotpInfoState({required this.handler});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new TOTP code'),
        actions: [],
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            shrinkWrap: true,
            children: [
              TextFormField(
                key: _domainKey,
                controller: _domainController,
                decoration: const InputDecoration(
                  labelText: 'Domain',
                  border: OutlineInputBorder(),
                ),
                autovalidateMode: AutovalidateMode.always,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a domain';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: _usernameKey,
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                autovalidateMode: AutovalidateMode.always,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                key: _secretKey,
                controller: _secretController,
                decoration: const InputDecoration(
                  labelText: 'Secret',
                  border: OutlineInputBorder(),
                ),
                autovalidateMode: AutovalidateMode.always,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a secret';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: TOTPType.totp,
                          child: Text(TOTPType.totp.name),
                        ),
                        DropdownMenuItem(
                          value: TOTPType.hotp,
                          child: Text(TOTPType.hotp.name),
                        ),
                      ],
                      value: _type,
                      onChanged: (value) {
                        setState(() {
                          _type = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: 'Algorithm',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: TOTPAlgorithm.sha1,
                          child: Text(TOTPAlgorithm.sha1.name),
                        ),
                        DropdownMenuItem(
                          value: TOTPAlgorithm.sha256,
                          child: Text(TOTPAlgorithm.sha256.name),
                        ),
                        DropdownMenuItem(
                          value: TOTPAlgorithm.sha512,
                          child: Text(TOTPAlgorithm.sha512.name),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          algorithm = value!;
                        });
                      },
                      value: algorithm,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: TextFormField(
                      key: _digitsKey,
                      controller: _digitsController,
                      decoration: const InputDecoration(
                        labelText: 'Digits',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter digits';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: TextFormField(
                      key: _periodKey,
                      controller: _periodController,
                      decoration: const InputDecoration(
                        labelText: 'Period',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter period';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: _countKey,
                controller: _countController,
                decoration: const InputDecoration(
                  labelText: 'Count',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.always,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter count';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    handler(
                      domain: _domainController.text,
                      username: _usernameController.text,
                      secret: _secretController.text,
                      algorithm: algorithm,
                      type: _type,
                      digits: int.parse(_digitsController.text),
                      period: int.parse(_periodController.text),
                      createdTimestamp: DateTime.now().millisecondsSinceEpoch,
                      counter: int.parse(_countController.text),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
