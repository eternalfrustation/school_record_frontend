import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_record_frontend/services/user.dart';

class SchoolCreate extends StatefulWidget {
  const SchoolCreate({super.key});

  @override
  State<StatefulWidget> createState() => _SchoolCreateState();
}

class _SchoolCreateState extends State<SchoolCreate> {
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final address = TextEditingController();
  final boardController = TextEditingController();
  Board? selectedBoard;
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
                controller: name,
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name is missing";
                  }
                  return null;
                },
                decoration:
                    const InputDecoration(labelText: "Enter School's name")),
            TextFormField(
                controller: address,
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Address is missing";
                  }
                  return null;
                },
                decoration:
                    const InputDecoration(labelText: "Enter School's address")),
            FormField(
              builder: (field) {
                return DropdownMenu<Board>(
                  initialSelection: null,

                  controller: boardController,
                  requestFocusOnTap: true,
                  label: const Text('Board'),
                  onSelected: (Board? board) {
                    field.didChange(board);
                    setState(() {
                      selectedBoard = board;
                    });
                  },
                  dropdownMenuEntries: [
                    ...Board.values
                        .map<DropdownMenuEntry<Board>>((Board board) {
                      return DropdownMenuEntry<Board>(
                        value: board,
                        label: board.toJson(),
                        enabled: true,
                      );
                    })
                  ],
                );
              },
              validator: (value) {
                if (value == null) {
                  return "Board is missing";
                }
                return null;
              },
            ),
            Consumer<UserState>(builder: (context, userState, child) {
              return TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final school = await userState.user?.addSchool(
                        name.text, address.text, selectedBoard!);
                    if (school != null) {
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
                child: const Text("Add School"),
              );
            })
          ],
        ));
  }
}
