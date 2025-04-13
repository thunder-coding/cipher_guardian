import 'package:cipher_guardian/passwords/generate.dart';
import 'package:flutter/material.dart';

class PasswordInfoWrapper extends StatelessWidget {
  const PasswordInfoWrapper({super.key, required this.handler});

  final Function handler;
  @override
  Widget build(BuildContext context) {
    return PasswordInfo(handler: handler);
  }
}

class PasswordInfo extends StatefulWidget {
  const PasswordInfo({super.key, required this.handler});

  final Function handler;
  @override
  State<StatefulWidget> createState() => _PasswordInfoState(handler: handler);
}

class _PasswordInfoState extends State<PasswordInfo> {
  bool generatedPassword = true;
  bool passwordObscure = true;
  PasswordType passwordType = PasswordType.alphaNumeric;
  AlphabetCase alphabetCase = AlphabetCase.mixed;
  bool includeSpecialChars = true;
  bool includeSpaces = true;
  bool strict = true;
  final _formKey = GlobalKey<FormState>();
  final _domainController = TextEditingController();
  final _usernameController = TextEditingController();
  final _lengthController = TextEditingController(text: '16');
  final _passwordController = TextEditingController();
  final _domainKey = GlobalKey<FormFieldState>();
  final _usernameKey = GlobalKey<FormFieldState>();
  final _lengthKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();

  final Function handler;

  _PasswordInfoState({required this.handler});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            shrinkWrap: true,
            children: [
              TextFormField(
                key: _domainKey,
                decoration: const InputDecoration(
                  labelText: 'Domain',
                  border: OutlineInputBorder(),
                ),
                controller: _domainController,
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
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                controller: _usernameController,
                autovalidateMode: AutovalidateMode.always,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Generate Password'),
                  Checkbox(
                    value: generatedPassword,
                    onChanged: (value) {
                      setState(() {
                        generatedPassword = value!;
                        passwordObscure = true;
                      });
                    },
                  ),
                ],
              ),
              Offstage(
                offstage: generatedPassword,
                child: TextFormField(
                  key: _passwordKey,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          passwordObscure = !passwordObscure;
                        });
                      },
                      icon:
                          passwordObscure
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                    ),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: passwordObscure,
                  controller: _passwordController,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
              ),
              Offstage(
                offstage: !generatedPassword,
                child: Column(
                  children: [
                    TextFormField(
                      key: _lengthKey,
                      decoration: const InputDecoration(
                        labelText: 'Length',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      controller: _lengthController,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a length';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Password Type'),
                    DropdownButtonFormField(
                      items: [
                        DropdownMenuItem(
                          value: PasswordType.alphaNumeric,
                          child: Text(
                            PasswordTypeExtension(
                              PasswordType.alphaNumeric,
                            ).name,
                          ),
                        ),
                        DropdownMenuItem(
                          value: PasswordType.alpha,
                          child: Text(
                            PasswordTypeExtension(PasswordType.alpha).name,
                          ),
                        ),
                        DropdownMenuItem(
                          value: PasswordType.numeric,
                          child: Text(
                            PasswordTypeExtension(PasswordType.numeric).name,
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        passwordType = value!;
                      },
                      value: passwordType,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    Offstage(
                      offstage: (passwordType == PasswordType.numeric),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const Text('Alphabet Case'),
                          DropdownButtonFormField(
                            items: const [
                              DropdownMenuItem(
                                value: AlphabetCase.mixed,
                                child: Text('Mixedcase'),
                              ),
                              DropdownMenuItem(
                                value: AlphabetCase.uppercase,
                                child: Text('Uppercase'),
                              ),
                              DropdownMenuItem(
                                value: AlphabetCase.lowercase,
                                child: Text('Lowercase'),
                              ),
                            ],
                            onChanged: (value) {},
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            value: alphabetCase,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheckboxListTile(
                          title: const Text('Include Special Characters'),

                          value: includeSpecialChars,
                          onChanged: (value) {
                            setState(() {
                              includeSpecialChars = value!;
                            });
                          },
                        ),

                        CheckboxListTile(
                          title: const Text('Include Spaces'),

                          value: includeSpaces,
                          onChanged: (value) {
                            setState(() {
                              includeSpaces = value!;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text('Strict'),

                          value: strict,
                          onChanged: (value) {
                            setState(() {
                              strict = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Create a button that says "Save" and "Generate"
              FilledButton(
                onPressed: () {
                  // Can't do this as all the fields are not visible which may also cause validation errors
                  // if (!_formKey.currentState!.validate()) {
                  //   return;
                  // }
                  if (!_domainKey.currentState!.validate() ||
                      !_usernameKey.currentState!.validate()) {
                    return;
                  }
                  if (generatedPassword) {
                    if (!_lengthKey.currentState!.validate()) {
                      return;
                    }
                  } else {
                    if (!_passwordKey.currentState!.validate()) {
                      return;
                    }
                  }
                  handler(
                    domain: _domainController.text,
                    username: _usernameController.text,
                    length: int.parse(_lengthController.text),
                    password: _passwordController.text,
                    generatedPassword: generatedPassword,
                    passwordType: passwordType,
                    alphabetCase: alphabetCase,
                    includeSpecialChars: includeSpecialChars,
                    includeSpaces: includeSpaces,
                    strict: strict,
                  );
                  Navigator.pop(context);
                },
                child: Text(generatedPassword ? 'Generate' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _domainController.dispose();
    _usernameController.dispose();
    _lengthController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
