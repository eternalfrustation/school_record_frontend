import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_record_frontend/components/enum_dropdown.dart';
import 'package:school_record_frontend/services/school.dart';

class SchoolCreateRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SchoolCreate();
}

class SchoolCreate extends StatefulWidget {
  const SchoolCreate({super.key});

  @override
  State<SchoolCreate> createState() => _SchoolCreateState();
}

class _SchoolCreateState extends State<SchoolCreate> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final boardController = TextEditingController();
  Board selectedBoard = Board.CBSE;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
                controller: nameController,
                autofocus: true,
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return "Name is missing";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "Name",
                    hintText: "Enter the name of the school")),
            TextFormField(
                controller: addressController,
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return "Address is missing";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "Address",
                    hintText: "Enter the address of the school")),
            EnumDropdownFormField(
                optionsList: Board.values,
                onChange: (board) {
                  setState(() {
                    selectedBoard = board;
                  });
                }),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await School.addSchool(
                      nameController.text,
                      addressController.text,
                      selectedBoard,
                    );
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: const Text("Create"))
          ],
        ));
  }
}
