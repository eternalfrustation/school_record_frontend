import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../components/classroom_info.dart';
import '../components/info_card.dart';
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
                InfoCard(data: classroom.dataField, buttons: [
                  TextButton(
                    onPressed: () {},
                    child: const Text("Delete Classroom"),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Edit Classroom"),
                  )
                ]),
                /*
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
							*/
              ])
            : const CircularProgressIndicator();
      },
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    setState(() {
      if (widget.id != null) {
        classroomFuture = Provider.of<UserState>(context, listen: false)
            .user
            ?.getClassroom(widget.id!);
      }
    });
  }
}

