import 'package:cipher_guardian/passwords/generate.dart';
import 'package:flutter/material.dart';

class PasswordInfoWrapper extends StatelessWidget {
  const PasswordInfoWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const PasswordInfo();
  }
}

class PasswordInfo extends StatefulWidget {
  const PasswordInfo({super.key});

  @override
  State<StatefulWidget> createState() => _PasswordInfoState();
}

class _PasswordInfoState extends State<PasswordInfo> {
  bool generatePassword = true;
  bool passwordObscure = true;
  PasswordType passwordType = PasswordType.alphaNumeric;
  AlphabetCase alphabetCase = AlphabetCase.mixed;
  bool includeSpecialChars = true;
  bool includeSpaces = true;
  bool strict = true;
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
          child: ListView(
            padding: const EdgeInsets.all(20),
            shrinkWrap: true,
            children: [
              // text input
              Hero(
                tag: 'domain',
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Domain',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Generate Password'),
                  Checkbox(
                    value: generatePassword,
                    onChanged: (value) {
                      setState(() {
                        generatePassword = value!;
                        passwordObscure = true;
                      });
                    },
                  ),
                ],
              ),
              Offstage(
                offstage: generatePassword,
                child: TextFormField(
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
                ),
              ),
              Offstage(
                offstage: !generatePassword,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Length',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    const Text('Password Type'),
                    DropdownButtonFormField(
                      items: const [
                        DropdownMenuItem(
                          value: PasswordType.alphaNumeric,
                          child: Text('Alpha Numeric'),
                        ),
                        DropdownMenuItem(
                          value: PasswordType.alpha,
                          child: Text('Alpha'),
                        ),
                        DropdownMenuItem(
                          value: PasswordType.numeric,
                          child: Text('Numeric'),
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
                  Navigator.pop(context);
                },
                child: Text(generatePassword ? 'Generate' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
