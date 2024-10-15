import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/user.dart';
import '../components/enum_dropdown.dart';
import '../components/search_table.dart';

class ClassroomPage extends StatefulWidget {
  const ClassroomPage({super.key, this.id});
  final int? id;

  @override
  State<StatefulWidget> createState() => _ClassroomPageState();
}

class _ClassroomPageState extends State<ClassroomPage> {
  List<Classroom> classrooms = [];
  Standard? selectedStandard;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(builder: (context, userState, child) {
      final user = userState.user!;
      return SearchTable(
          button: TextButton(
              onPressed: () {
                context.go("/create/member?id=${widget.id}");
              },
              child: const Text("Add Classroom")),
          label: "Search classrooms",
          extraSearchWidgets: [
            Expanded(
                child: EnumDropdownFormField<Standard>(
              onChange: (v) {
                setState(() {
                  selectedStandard = v;
                });
              },
              optionsList: Standard.values,
            ))
          ],
          defaultList: user
              .searchClassroom(schoolId: widget.id)
              .then((u) => u?.map((s) => s.dataField).toList()),
          searchFunction: (s) => user
              .searchClassroom(standard: selectedStandard, schoolId: widget.id)
              .then((u) => u?.map((s) => s.dataField).toList()));
    });
  }
}
