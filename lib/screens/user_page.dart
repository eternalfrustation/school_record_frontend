import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

import '../components/delete_dialog.dart';
import '../components/info_card.dart';
import '../services/user.dart';

class UserPage extends StatefulWidget {
  final int? id;
  const UserPage({super.key, this.id});

  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with AfterLayoutMixin<UserPage> {
  Future<User?>? userFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userFuture,
      builder: (context, snapshot) {
        final user = snapshot.data;
        return user != null
            ? Column(children: [
                InfoCard(
                  data: user.dataField,
                  buttons: [
                    TextButton(
                        onPressed: () {
                          context.go("/user/edit?id=${user.id}");
                        },
                        child: const Text("Edit User")),
                    if (canDelete(user.role))
                      TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return deleteDialog(context, user.name, () {
                                    final user =
                                        Provider.of<UserState>(context).user;
                                    if (user == null) {
                                      return null;
                                    }
                                    return user.deleteUser(user.id);
                                  });
                                });
                          },
                          child: const Text("Delete User")),
                  ],
                ),
                if (user.role == Role.TEACHER || user.role == Role.SCHOOL_ADMIN)
                  TextButton(
                    onPressed: () {
                      context.go("/classes?teacher_id=${user.id}");
                    },
                    child: const Text("View assigned classes"),
                  ),
                if (user.role == Role.STUDENT)
                  TextButton(
                    onPressed: () {
                      context.go("/classes?student_id=${user.id}");
                    },
                    child: const Text("View enrolled classes"),
                  ),
                TextButton(
                  onPressed: () {
                    context.go("/announcements?user_id=${user.id}");
                  },
                  child: const Text("View user announcements"),
                )
              ])
            : const CircularProgressIndicator();
      },
    );
  }

  bool canDelete(Role targetUserRole) {
    final roleHierarchy = [
      Role.STUDENT,
      Role.TEACHER,
      Role.SCHOOL_ADMIN,
      Role.PRINCIPAL,
      Role.SUPER_ADMIN
    ];
    final user = Provider.of<UserState>(context).user;
    if (user == null) {
      return false;
    }

    return roleHierarchy.indexOf(user.role) >
        roleHierarchy.indexOf(targetUserRole);
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    setState(() {
      userFuture = Provider.of<UserState>(context, listen: false)
          .user
          ?.getUser(widget.id);
    });
  }
}
