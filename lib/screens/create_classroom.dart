import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_record_frontend/services/user.dart';

class CreateClassroom extends StatefulWidget {
  final int? id;
  const CreateClassroom({super.key, this.id});

  @override
  State<CreateClassroom> createState() => _CreateClassroomState();
}

class _CreateClassroomState extends State<CreateClassroom> {
  final _formKey = GlobalKey<FormState>();
  final sectionController = TextEditingController();
  final whatsappLinkController = TextEditingController();
  Standard? selectedStandard;

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);
    final isSuperAdmin = userState.user?.role == Role.SUPER_ADMIN;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: sectionController,
            decoration: const InputDecoration(labelText: "Section"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Section is required";
              }
              return null;
            },
          ),
          DropdownButtonFormField<Standard>(
            value: selectedStandard,
            decoration: const InputDecoration(labelText: "Standard"),
            items: Standard.values.map((Standard standard) {
              return DropdownMenuItem<Standard>(
                value: standard,
                child: Text(standard.toString().split('.').last),
              );
            }).toList(),
            onChanged: (Standard? newValue) {
              setState(() {
                selectedStandard = newValue;
              });
            },
            validator: (value) {
              if (value == null) {
                return "Standard is required";
              }
              return null;
            },
          ),
          TextFormField(
            controller: whatsappLinkController,
            decoration: const InputDecoration(labelText: "Whatsapp Link"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Whatsapp Link is required";
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final classroom = await userState.user?.addClassroom(
                  section: sectionController.text,
                  standard: selectedStandard!,
				  whatsappLink: whatsappLinkController.text,
                  schoolId: isSuperAdmin
                      ? widget.id ?? userState.user!.school_id
                      : userState.user!.school_id,
                );
                if (classroom != null) {
                  if (context.mounted) {
                    context.go("/dashboard");
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Network Error')),
                    );
                  }
                }
              }
            },
            child: const Text("Add Classroom"),
          ),
        ],
      ),
    );
  }
}
