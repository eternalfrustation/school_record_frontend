import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/user.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<StatefulWidget> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
                controller: emailController,
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Username is missing";
                  }
                  return null;
                },
                decoration:
                    const InputDecoration(labelText: "Enter your E-Mail")),
            TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration:
                    const InputDecoration(labelText: "Enter your Password"),
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is missing";
                  }
                  return null;
                }),
            Consumer<UserState>(builder: (context, userState, child) {
              return TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (await userState.signIn(
                        emailController.text, passwordController.text)) {
                      if (context.mounted) {
                        context.go("/dashboard");
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Incorrect email or password')),
                        );
                      }
                    }
                  }
                },
                child: const Text("Log In"),
              );
            })
          ],
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
