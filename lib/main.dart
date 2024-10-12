import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_record_frontend/screens/create_school.dart';
import 'package:school_record_frontend/screens/school_page.dart';
import 'package:school_record_frontend/screens/sign_in.dart';

import 'screens/classroom_details_page.dart';
import 'screens/classroom_page.dart';
import 'screens/create_classroom.dart';
import 'screens/create_user.dart';
import 'screens/dashboard.dart';
import 'screens/landing.dart';
import 'screens/members.dart';
import 'screens/school_edit_page.dart';
import 'screens/user_page.dart';
import 'services/user.dart';

void main() {
  usePathUrlStrategy();
  var userState = UserState();
  userState.syncWithBackend();
  runApp(ChangeNotifierProvider(
      lazy: true,
      create: (context) => userState,
      child: const SchoolRecordsApp()));
}

class SchoolRecordsApp extends StatefulWidget {
  const SchoolRecordsApp({super.key, user});

  @override
  State<SchoolRecordsApp> createState() => _SchoolRecordsAppState();
}

class ScaffoldWrapper extends StatelessWidget {
  final Widget child;
  final String? title;

  const ScaffoldWrapper({super.key, required this.child, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'School Records'),
      ),
      body: child,
    );
  }
}

class _SchoolRecordsAppState extends State<SchoolRecordsApp> {
  User? user;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(builder: (context, userState, child) {
      return MaterialApp.router(
        title: 'School Records',
        routerConfig: GoRouter(
          redirect: (context, state) {
            if (userState.user == null) {
              return '/sign_in';
            }
            if (state.uri.path.isEmpty || state.uri.path == "/") {
              return "/dashboard";
            }
            return null;
          },
          routes: [
            GoRoute(
              path: '/',
              pageBuilder: (context, state) => const MaterialPage(
                  child: ScaffoldWrapper(child: LandingPage())),
            ),
            GoRoute(
              path: '/sign_in',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: ScaffoldWrapper(child: SignIn())),
            ),
            GoRoute(
              path: '/dashboard',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: Scaffold(body: Dashboard())),
            ),
            GoRoute(
              path: '/create/school',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: Scaffold(body: CreateSchool())),
            ),
            GoRoute(
                path: '/school',
                pageBuilder: (context, state) => MaterialPage(
                      child: Scaffold(
                          body: SchoolPage(
                              id: int.tryParse(
                                  state.uri.queryParameters["id"] ?? ""))),
                    )),
            GoRoute(
              path: '/school/edit',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: SchoolEditPage(
                          id: int.tryParse(
                              state.uri.queryParameters["id"] ?? "")))),
            ),
            GoRoute(
              path: '/members',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: Members(
                          id: int.tryParse(
                              state.uri.queryParameters["school_id"] ?? "")))),
            ),
            GoRoute(
              path: '/create/member',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: CreateMember(
                          id: int.tryParse(
                              state.uri.queryParameters["id"] ?? "")))),
            ),
            GoRoute(
                path: '/user',
                pageBuilder: (context, state) => MaterialPage(
                      child: Scaffold(
                          body: UserPage(
                              id: int.tryParse(
                                  state.uri.queryParameters["id"] ?? ""))),
                    )),
            GoRoute(
                path: '/classroom',
                pageBuilder: (context, state) => MaterialPage(
                      child: Scaffold(
                          body: ClassroomDetailsPage(
                              id: int.tryParse(
                                  state.uri.queryParameters["id"] ?? ""))),
                    )),
            GoRoute(
                path: '/school/classroom',
                pageBuilder: (context, state) => MaterialPage(
                      child: Scaffold(
                          body: ClassroomPage(
                              id: int.tryParse(
                                  state.uri.queryParameters["school_id"] ?? ""))),
                    )),
            GoRoute(
                path: '/create/classroom',
                pageBuilder: (context, state) => MaterialPage(
                      child: Scaffold(
                          body: CreateClassroom(
                              id: int.tryParse(
                                  state.uri.queryParameters["id"] ?? ""))),
                    )),
            /*
            GoRoute(
              path: '/classes',
              pageBuilder: (context, state) =>
								// TODO: Make the School classes page
                  const MaterialPage(child: Scaffold(body: SchoolMembers())),
            ),
            GoRoute(
              path: '/students',
              pageBuilder: (context, state) =>
								// TODO: Make the School students page
                  const MaterialPage(child: Scaffold(body: SchoolMembers())),
            ),
            GoRoute(
              path: '/announcements',
              pageBuilder: (context, state) =>
								// TODO: Make the Announcements page
                  const MaterialPage(child: Scaffold(body: Announcements page())),
            ),
						*/
          ],
        ),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8B67F6)),
          useMaterial3: true,
        ),
      );
    });
  }
}
