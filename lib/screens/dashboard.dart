import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_record_frontend/screens/dashboard/super_admin.dart';

import '../services/user.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(builder: (context, userState, child) {
      final user = userState.user;

      if (user == null) {
        return const CircularProgressIndicator.adaptive();
      }

      return switch (user.role) {
        Role.SUPER_ADMIN => const SuperAdminDashboard(),
        Role.PRINCIPAL => const CircularProgressIndicator.adaptive(),
        // TODO: Handle this case.
        Role.SCHOOL_ADMIN => const CircularProgressIndicator.adaptive(),
        // TODO: Handle this case.
        Role.TEACHER => const CircularProgressIndicator.adaptive(),
        // TODO: Handle this case.
        Role.STUDENT => const CircularProgressIndicator.adaptive()
        // TODO: Handle this case.
      };
    });
  }
}
