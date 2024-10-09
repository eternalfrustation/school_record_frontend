import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/user.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(builder: (context, userState, child) {
	  final user = userState.user;
      if (user == null) {
        context.go("/sign_in");
      } else {
		switch (user.role) {
			case Role.SUPER_ADMIN:
				context.go("/dashboard/super_admin");
			case Role.PRINCIPAL:
				context.go("/dashboard/principal");
			case Role.SCHOOL_ADMIN:
				context.go("/dashboard/school_admin");
			case Role.TEACHER:
				context.go("/dashboard/teacher");
			case Role.STUDENT:
				context.go("/dashboard/student");
		}
      }
      return const CircularProgressIndicator.adaptive();
    });
  }
}
