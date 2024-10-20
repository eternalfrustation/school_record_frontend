import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_record_frontend/components/delete_dialog.dart';
import 'package:school_record_frontend/components/info_card.dart';
import 'package:school_record_frontend/routes/dashboard.dart';
import 'package:school_record_frontend/routes/schools/users/edit.dart';
import 'package:school_record_frontend/services/user.dart';

class UserInfoRoute extends GoRouteData {
  final int user_id;
  UserInfoRoute({required this.user_id});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return UserInfo(id: user_id);
  }
}

class UserInfo extends StatelessWidget {
  final int id;
  final Future<User> userFuture;
  UserInfo({super.key, required this.id}) : userFuture = User.getUser(id);

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      data: userFuture.then((user) => user.dataField),
      buttons: [
        TextButton(
          child: const Text("Edit"),
          onPressed: () {
            UserEditRoute(user_id: id).go(context);
          },
        ),
        TextButton(
          child: const Text("Delete"),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => deleteDialog(context, "", () {
                return userFuture.then((user) {
                  user.deleteUser();
                });
              }),
            );
          },
        ),
      ],
    );
  }
}
