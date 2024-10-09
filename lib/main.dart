import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_record_frontend/screens/sign_in.dart';

import 'screens/dashboard.dart';
import 'screens/landing.dart';
import 'services/user.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => UserState(), child: const SchoolRecordsApp()));
}

class SchoolRecordsApp extends StatefulWidget {
  const SchoolRecordsApp({super.key, user});

  @override
  State<SchoolRecordsApp> createState() => _SchoolRecordsAppState();
}

final _router = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => const LandingPage()),
  GoRoute(path: "/sign_in", builder: (context, state) => const SignIn()),
  GoRoute(path: "/dashboard", builder: (context, state) => const Dashboard()),
  GoRoute(path: "/dashboard/super_admin", builder: (context, state) => const SuperAdminDashboard())
]);

class _SchoolRecordsAppState extends State<SchoolRecordsApp> {
  User? user;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'School Records',
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8B67F6)),
        useMaterial3: true,
      ),
    );
  }
}
