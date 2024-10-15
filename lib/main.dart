import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_record_frontend/screens/create_school.dart';
import 'package:school_record_frontend/screens/school_page.dart';
import 'package:school_record_frontend/screens/sign_in.dart';

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
                path: '/school',
                pageBuilder: (context, state) => MaterialPage(
                      child: Scaffold(
                          body: SchoolPage(
                              id: int.tryParse(
                                  state.uri.queryParameters["id"] ?? ""))),
                    )),
            GoRoute(
              path: '/school/create',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: Scaffold(body: SchoolCreate())),
            ),
            GoRoute(
              path: '/school/edit',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: SchoolEdit(
                          id: int.tryParse(
                              state.uri.queryParameters["id"] ?? "")))),
            ),
            GoRoute(
                path: '/school/courses',
                pageBuilder: (context, state) => MaterialPage(
                      child: Scaffold(
                          body: Courses(
                              id: int.tryParse(
                                  state.uri.queryParameters["id"] ?? ""))),
                    )),
            GoRoute(
                path: '/school/courses/create',
                pageBuilder: (context, state) => MaterialPage(
                      child: Scaffold(
                          body: CoursesCreate(
                              id: int.tryParse(
                                  state.uri.queryParameters["id"] ?? ""))),
                    )),
            GoRoute(
              path: '/users',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: Users(
                          id: int.tryParse(
                              state.uri.queryParameters["school_id"] ?? "")))),
            ),
            GoRoute(
              path: '/users/create',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: UserCreate(
                          id: int.tryParse(
                              state.uri.queryParameters["school_id"] ?? "")))),
            ),
            GoRoute(
              path: '/users/edit',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: UserEdit(
                          id: int.tryParse(
                              state.uri.queryParameters["id"] ?? "")))),
            ),
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: Profile(
                          id: int.tryParse(
                              state.uri.queryParameters["id"] ?? "")))),
            ),
            GoRoute(
              path: '/school/announcements',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: SchoolAnnouncements(
                          id: int.tryParse(
                              state.uri.queryParameters["school_id"] ?? "")))),
            ),
            GoRoute(
              path: '/school/announcements/create',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: SchoolAnnouncementsCreate(
                          id: int.tryParse(
                              state.uri.queryParameters["school_id"] ?? "")))),
            ),
            GoRoute(
              path: '/school/announcements/edit',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: SchoolAnnouncementsEdit(
                          id: int.tryParse(
                              state.uri.queryParameters["id"] ?? "")))),
            ),
            GoRoute(
              path: '/school/classrooms',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: Classrooms(
                          id: int.tryParse(
                              state.uri.queryParameters["school_id"] ?? "")))),
            ),
            GoRoute(
              path: '/school/classrooms/create',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: ClassroomsCreate(
                          id: int.tryParse(
                              state.uri.queryParameters["school_id"] ?? "")))),
            ),
            GoRoute(
              path: '/school/classrooms/edit',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: ClassroomsEdit(
                          id: int.tryParse(
                              state.uri.queryParameters["id"] ?? "")))),
            ),
            GoRoute(
              path: '/school/classroom',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: Classroom(
                          id: int.tryParse(
                              state.uri.queryParameters["id"] ?? "")))),
            ),
            GoRoute(
              path: '/school/classroom/students',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: ClassroomStudents(
                          id: int.tryParse(
                              state.uri.queryParameters["id"] ?? "")))),
            ),
            GoRoute(
              path: '/school/classroom/students/create',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: ClassroomStudentsCreate(
                          id: int.tryParse(
                              state.uri.queryParameters["id"] ?? "")))),
            ),
            GoRoute(
              path: '/school/classroom/assignment',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: Assignments(
                          id: int.tryParse(
                              state.uri.queryParameters["id"] ?? "")))),
            ),
            GoRoute(
              path: '/school/classroom/assignment/create',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: AssignmentsCreate(
                          id: int.tryParse(
                              state.uri.queryParameters["id"] ?? "")))),
            ),
            GoRoute(
              path: '/school/classroom/assignment/edit',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: AssignmentsEdit(
                          id: int.tryParse(
                              state.uri.queryParameters["id"] ?? "")))),
            ),
            GoRoute(
              path: '/school/classroom/teacher',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: Teachers(
                          id: int.tryParse(
                              state.uri.queryParameters["id"] ?? "")))),
            ),
            GoRoute(
              path: '/school/classroom/teacher/create',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: TeacherCreate(
                          id: int.tryParse(
                              state.uri.queryParameters["id"] ?? "")))),
            ),
            GoRoute(
              path: '/school/classroom/student',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: Students(
                          id: int.tryParse(
                              state.uri.queryParameters["id"] ?? "")))),
            ),
            GoRoute(
              path: '/school/classroom/student/create',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: StudentCreate(
                          id: int.tryParse(
                              state.uri.queryParameters["id"] ?? "")))),
            ),
            GoRoute(
              path: '/school/classroom/announcement',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: ClassroomAnnouncements(
                          id: int.tryParse(
                              state.uri.queryParameters["id"] ?? "")))),
            ),
            GoRoute(
              path: '/school/classroom/announcement/create',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: ClassroomAnnouncementsCreate(
                          id: int.tryParse(
                              state.uri.queryParameters["id"] ?? "")))),
            ),
            GoRoute(
              path: '/school/classroom/announcement/edit',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: ClassroomAnnouncementsEdit(
                          id: int.tryParse(
                              state.uri.queryParameters["id"] ?? "")))),
            ),
            GoRoute(
              path: '/school/classroom/assignment',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: ClassroomAssignments(
                          id: int.tryParse(
                              state.uri.queryParameters["id"] ?? "")))),
            ),
            GoRoute(
              path: '/school/classroom/assignment/create',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: ClassroomAssignmentsCreate(
                          id: int.tryParse(
                              state.uri.queryParameters["id"] ?? "")))),
            ),
            GoRoute(
              path: '/school/classroom/assignment/edit',
              pageBuilder: (context, state) => MaterialPage(
                  child: Scaffold(
                      body: ClassroomAssignmentsEdit(
                          id: int.tryParse(
                              state.uri.queryParameters["id"] ?? "")))),
            ),
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
