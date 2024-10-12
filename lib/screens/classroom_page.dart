import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_record_frontend/components/classroom_info.dart';

import '../../services/user.dart';

class ClassroomPage extends StatefulWidget {
  const ClassroomPage({super.key, this.id});
  final int? id;

  @override
  State<StatefulWidget> createState() => _ClassroomPageState();
}

class _ClassroomPageState extends State<ClassroomPage> {
  List<Classroom> classrooms = [];
  final standardController = TextEditingController();
  Standard? selectedStandard;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(builder: (context, userState, child) {
      return Column(children: [
        const Text("Search classrooms"),
        Row(children: [
          DropdownMenu<Standard>(
            initialSelection: null,
            controller: standardController,
            requestFocusOnTap: true,
            label: const Text('Standard'),
            onSelected: (standard) {
              setState(() {
                selectedStandard = standard;
              });
            },
            dropdownMenuEntries: [
              ...Standard.values
                  .map<DropdownMenuEntry<Standard>>((Standard standard) {
                return DropdownMenuEntry<Standard>(
                  value: standard,
                  label: standard.toString(),
                  enabled: true,
                );
              })
            ],
          ),
          Expanded(child: TextField(
            onChanged: (s) async {
              List<Classroom> newClassrooms = await userState.user
                      ?.searchClassroom(
                          standard: selectedStandard, schoolId: widget.id) ??
                  [];
              if (newClassrooms == classrooms) {
                return;
              }
              setState(() {
                classrooms = newClassrooms;
              });
            },
          )),
          SizedBox(
              width: 150,
              child: TextButton(
                  onPressed: () {
                    context.go("/create/classroom?id=${widget.id}");
                  },
                  child: const Text("Add Classroom")))
        ]),
        userState.user != null
            ? FutureBuilder<List<Classroom>?>(
                future: userState.user!.searchClassroom(
                    schoolId: widget.id ?? userState.user!.school_id),
                builder: (context, snapshot) {
                  return Column(
                      children: classrooms.isEmpty
                          ? (snapshot.hasData
                              ? snapshot.data!
                                  .map((s) => ClassroomRow(classroom: s))
                                  .toList()
                              : [])
                          : classrooms
                              .map((s) => ClassroomRow(classroom: s))
                              .toList());
                })
            : const CircularProgressIndicator()
      ]);
    });
  }
}
