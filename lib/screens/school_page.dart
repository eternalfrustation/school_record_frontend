import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../components/delete_dialog.dart';
import '../components/info_card.dart';
import '../services/user.dart';

class SchoolPage extends StatefulWidget {
  final int? id;
  const SchoolPage({super.key, this.id});

  @override
  State<StatefulWidget> createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage>
    with AfterLayoutMixin<SchoolPage> {
  Future<School?>? schoolFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: schoolFuture,
      builder: (context, snapshot) {
        final school = snapshot.data;
        return school != null
            ? Column(children: [
                InfoCard(
                  data: school.dataField,
                  buttons: [
                    TextButton(
                        onPressed: () {
                          context.go("/school/edit?id=${school.id}");
                        },
                        child: const Text("Edit School")),
                    TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  deleteDialog(context, school.name, () {
                                    final userState =
                                        Provider.of<UserState>(context);
                                    return userState.user
                                        ?.deleteSchool(school.id);
                                  }));
                        },
                        child: const Text("Delete School")),
                  ],
                ),
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
