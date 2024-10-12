import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/user.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(builder: (context, userState, child) {
      return const CircularProgressIndicator.adaptive();
    });
  }
}
