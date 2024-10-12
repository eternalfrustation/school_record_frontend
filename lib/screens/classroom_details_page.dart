import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../components/classroom_info.dart';
import '../services/user.dart';

class ClassroomDetailsPage extends StatefulWidget {
  final int? id;
  const ClassroomDetailsPage({super.key, this.id});

  @override
  State<StatefulWidget> createState() => _ClassroomDetailsPageState();
}

class _ClassroomDetailsPageState extends State<ClassroomDetailsPage>
    with AfterLayoutMixin<ClassroomDetailsPage> {
  Future<Classroom?>? classroomFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: classroomFuture,
      builder: (context, snapshot) {
        final classroom = snapshot.data;
        return classroom != null
            ? Column(children: [
                ClassroomRow(classroom: classroom),
                TextButton(
                  onPressed: () {
                    context.go("/members?school_id=${school.id}");
                  },
                  child: const Text("View list of members in organization"),
                ),
                TextButton(
                  onPressed: () {
                    context.go("/school/classroom?school_id=${school.id}");
                  },
                  child: const Text("View list of all classes"),
                ),
                TextButton(
                  onPressed: () {
                    context.go("/students?school_id=${school.id}");
                  },
                  child: const Text("View list of students"),
                ),
                TextButton(
                  onPressed: () {
                    context.go("/announcements?school_id=${school.id}");
                  },
                  child: const Text("Go to the announcements page"),
                )
              ])
            : const CircularProgressIndicator();
      },
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    setState(() {
      schoolFuture = Provider.of<UserState>(context, listen: false)
          .user
          ?.getSchool(widget.id);
    });
  }
}

class SchoolDetailsCard extends StatelessWidget {
  final School school;
  const SchoolDetailsCard({super.key, required this.school});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      !school.photo
          ? Row(children: [
              FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage, image: school.photoUrl),
              Column(children: [
                Text(school.name),
                Row(children: [
                  const Text("Board"),
                  Text(school.board.toJson())
                ])
              ])
            ])
          : Column(children: [
              Text(school.name),
              Row(children: [
                const Text("Board: "),
                Text(school.board.toJson())
              ])
            ]),
      Row(children: [const Text("Address: "), Text(school.address)]),
      Row(children: [
        const Text("Subscribed Since: "),
        Text(DateFormat.yMMMd().format(school.subscriptionStart))
      ]),
      Row(children: [
        TextButton(
            onPressed: () {
              context.go("/school/edit?id=${school.id}");
            },
            child: const Text("Edit School")),
        TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Delete ${school.name}?"),
                      content: Text(
                          "Are you sure that you want to delete ${school.name} with id ${school.id}"),
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
                                await userState.user?.deleteSchool(school.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Successfully deleted school ${school.name}')),
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
            child: const Text("Delete School")),
      ]),
    ]);
  }
}
