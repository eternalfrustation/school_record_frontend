import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/user.dart';

class SuperAdminDashboard extends StatelessWidget {
  const SuperAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(builder: (context, userState, child) {
      final user = userState.user;
      if (user == null) {
        context.go("/sign_in");
      } else if (user.role != Role.SUPER_ADMIN) {
        context.go("/dashboard");
      }
      return const CircularProgressIndicator.adaptive();
    });
  }
}
