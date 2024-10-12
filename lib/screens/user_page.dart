import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

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
                UserDetailsCard(user: user),
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

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    setState(() {
      userFuture = Provider.of<UserState>(context, listen: false)
          .user
          ?.getUser(widget.id);
    });
  }
}

class UserDetailsCard extends StatelessWidget {
  final User user;
  const UserDetailsCard({super.key, required this.user});

  bool canDelete(Role currentUserRole, Role targetUserRole) {
    final roleHierarchy = [
      Role.STUDENT,
      Role.TEACHER,
      Role.SCHOOL_ADMIN,
      Role.PRINCIPAL,
      Role.SUPER_ADMIN
    ];
    return roleHierarchy.indexOf(currentUserRole) >
        roleHierarchy.indexOf(targetUserRole);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserState>(context, listen: false).user;

    return Column(children: [
      user.photo
          ? Row(children: [
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: user.photoUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              Column(children: [
                Text('${user.fname} ${user.lname}'),
                Text(user.role.toString().split('.').last)
              ])
            ])
          : Column(children: [
              Text('${user.fname} ${user.lname}'),
              Text(user.role.toString().split('.').last)
            ]),
      Row(children: [const Text("Email: "), Text(user.email)]),
      Row(children: [const Text("Contact: "), Text(user.contact)]),
      Row(children: [
        const Text("Date of Birth: "),
        Text(DateFormat.yMMMd().format(user.dob))
      ]),
      Row(children: [
        TextButton(
            onPressed: () {
              context.go("/user/edit?id=${user.id}");
            },
            child: const Text("Edit User")),
        if (currentUser != null && canDelete(currentUser.role, user.role))
          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Delete ${user.fname} ${user.lname}?"),
                        content: Text(
                            "Are you sure that you want to delete ${user.fname} ${user.lname} with id ${user.id}?"),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              context.pop();
                            },
                          ),
                          Consumer<UserState>(
                            builder: (context, userState, child) {
                              return TextButton(
                                child: const Text("Delete"),
                                onPressed: () async {
                                  await userState.user?.deleteUser(user.id);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Successfully deleted user ${user.fname} ${user.lname}')),
                                    );
                                    context.pop();
                                    context.go("/dashboard");
                                  }
                                },
                              );
                            },
                          )
                        ],
                      );
                    });
              },
              child: const Text("Delete User")),
      ]),
    ]);
  }
}
