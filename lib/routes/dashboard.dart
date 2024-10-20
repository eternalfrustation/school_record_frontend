import 'package:flutter/material.dart';
import 'package:flutter_async_widgets/widgets/async_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:school_record_frontend/components/info_card.dart';
import 'package:school_record_frontend/routes/schools/create.dart';
import 'package:school_record_frontend/routes/schools/edit.dart';
import 'package:school_record_frontend/routes/schools/info.dart';
import 'package:school_record_frontend/routes/schools/schools.dart';
import 'package:school_record_frontend/routes/schools/users/create.dart';
import 'package:school_record_frontend/routes/schools/users/edit.dart';
import 'package:school_record_frontend/routes/schools/users/info.dart';
import 'package:school_record_frontend/routes/schools/users/users.dart';
import 'package:school_record_frontend/routes/sign_in.dart';
import 'package:school_record_frontend/services/user.dart';

part 'dashboard.g.dart';

@TypedGoRoute<DashboardRoute>(path: '/', routes: [
  // Add sub-routes
  TypedGoRoute<SignInRoute>(
    path: 'sign_in',
  ),
  TypedGoRoute<SchoolsListRoute>(path: 'schools', routes: [
    TypedGoRoute<SchoolCreateRoute>(
      path: 'create',
    ),
    TypedGoRoute<SchoolEditRoute>(
      path: 'edit/:school_id',
    ),
    TypedGoRoute<SchoolInfoRoute>(
      path: ':school_id',
    ),
    TypedGoRoute<UsersListRoute>(
      path: 'users',
      routes: [
        TypedGoRoute<UserCreateRoute>(
          path: 'create/:school_id',
        ),
        TypedGoRoute<UserEditRoute>(
          path: 'edit/:user_id',
        ),
        TypedGoRoute<UserInfoRoute>(
          path: ':user_id',
        ),
      ],
    ),
  ])
  /*
    TypedGoRoute<AnnouncementsListRoute>(
      path: 'announcements',
      routes: [
        TypedGoRoute<AnnouncementsCreateRoute>(
          path: 'create/:school_id',
        ),
        TypedGoRoute<AnnouncementsEditRoute>(
          path: 'edit/:school_id',
        ),
        TypedGoRoute<AnnouncementInfoRoute>(
          path: ':announcement_id',
        ),
      ],
    ),
    TypedGoRoute<CoursesListRoute>(
      path: 'courses',
      routes: [
        TypedGoRoute<CoursesCreateRoute>(
          path: 'create/:school_id',
        ),
        TypedGoRoute<CoursesEditRoute>(
          path: 'edit/:school_id',
        ),
      ],
    ),
    TypedGoRoute<ClassroomsListRoute>(
      path: 'classrooms',
      routes: [
        TypedGoRoute<ClassroomCreateRoute>(
          path: 'create/:school_id',
        ),
        TypedGoRoute<ClassroomEditRoute>(
          path: 'edit/:school_id',
        ),
        TypedGoRoute<ClassroomInfoRoute>(
          path: ':classroom_id',
        ),
        TypedGoRoute<AssignmentsInfoRoute>(path: '/assignments', routes: [
          TypedGoRoute<AssignmentsCreateRoute>(
            path: 'create/:classroom_id',
          ),
          TypedGoRoute<AssignmentsEditRoute>(
            path: 'edit/:assignment_id',
          ),
          TypedGoRoute<AssignmentsListRoute>(
            path: ':classroom_id',
          ),
          TypedGoRoute<AssignmentsSubmitRoute>(
            path: 'submit/:assignment_id',
          ),
          TypedGoRoute<AssignmentsVerifyRoute>(
            path: 'verify/:assignment_id',
          ),
        ]),
        TypedGoRoute<ClassroomAnnouncementsListRoute>(
            path: 'announcements',
            routes: [
              TypedGoRoute<ClassroomAnnouncementsCreateRoute>(
                path: 'create/:classroom_id',
              ),
              TypedGoRoute<ClassroomAnnouncementsEditRoute>(
                path: 'edit/:classroom_id',
              ),
              TypedGoRoute<ClassroomAnnouncementsInfoRoute>(
                path: ':announcement_id',
              ),
            ]),
        TypedGoRoute<TeacherListRoute>(path: 'teacher', routes: [
          TypedGoRoute<TeacherCreateRoute>(
            path: 'create/:classroom_id',
          ),
          TypedGoRoute<TeacherEditRoute>(
            path: 'edit/:classroom_id',
          ),
          TypedGoRoute<TeacherInfoRoute>(
            path: ':teacher_id',
          ),
        ]),
      ],
    ),
  ]),
	*/
])
class DashboardRoute extends GoRouteData {
  const DashboardRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => Dashboard();
}

class Dashboard extends StatelessWidget {
  Dashboard({super.key});
  final userFuture = User.currentUser();
  @override
  Widget build(BuildContext context) {
    return AsyncBuilder.single(userFuture, onData: (context, data) {
      return Column(children: [
        InfoCard(
          data: Future.value(data.dataField),
          buttons: [
            TextButton(
              child: const Text("Edit"),
              onPressed: () {
                try {
                  print(data.toJson());
                  UserEditRoute().go(context);
                } catch (e, s) {
                  print("Error was $e");
                  print("Stack trace was $s");
                }
              },
            )
          ],
        ),
        TextButton(
            child: const Text("Schools List"),
            onPressed: () {
              SchoolsListRoute().go(context);
            }),
      ]);
    }, onLoading: (context) {
      return const LinearProgressIndicator(
        value: null,
        semanticsLabel: 'User loading',
      );
    }, onError: (context, e) {
      return const LinearProgressIndicator(
        color: Color.fromARGB(255, 255, 30, 30),
        value: null,
        semanticsLabel: 'User loading',
      );
    });
  }
}
