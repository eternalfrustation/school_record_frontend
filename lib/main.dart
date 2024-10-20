import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:http/browser_client.dart';
import 'package:school_record_frontend/routes/sign_in.dart';
import 'package:school_record_frontend/services/user.dart';

import 'routes/dashboard.dart';

void main() {
  usePathUrlStrategy();
  runApp(SchoolRecordsApp());
}

const baseUrl = "http://localhost:3000";
final webClient = BrowserClient()..withCredentials = true;

// Define how your route tree (path and sub-routes)

class SchoolRecordsApp extends StatelessWidget {
  SchoolRecordsApp({super.key});

  late final _router = GoRouter(
    redirect: (context, state) async {
      try {
        await User.currentUser();
      } catch (e) {
        return const SignInRoute().location;
      }
      return null;
    },
    routes: $appRoutes,
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'School Records',
      builder: (context, child) {
        return Scaffold(
            appBar: AppBar(title: const Text('School Records')), body: child);
      },
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerConfig: _router,
    );
  }
}
