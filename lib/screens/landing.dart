import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/user.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(builder: (context, userState, child) {
      if (userState.user == null) {
        context.go("/sign_in");
      } else {
        context.go("/dashboard");
      }
      return const CircularProgressIndicator.adaptive();
    });
  }
}
