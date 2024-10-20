import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_record_frontend/routes/dashboard.dart';
import 'package:school_record_frontend/services/user.dart';

class SignInRoute extends GoRouteData {
  const SignInRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const SignIn();
}

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
    return Column(children: [
      Form(
          key: _formKey,
          child: Column(children: [
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
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  User.signIn(emailController.text, passwordController.text)
                      .then((user) {
                    if (context.mounted) {
                      const DashboardRoute().go(context);
                    }
                  }).catchError((e) {
                    print(e);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Incorrect email or password')),
                      );
                    }
                  });
                }
              },
              child: const Text("Log In"),
            )
          ]))
    ]);
  }
}
