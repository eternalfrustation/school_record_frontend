import 'package:flutter/material.dart';
import 'package:flutter_async_widgets/widgets/async_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:school_record_frontend/routes/dashboard.dart';
import 'package:school_record_frontend/services/school.dart';

class SchoolEditRoute extends GoRouteData {
  final int school_id;

  SchoolEditRoute({required this.school_id});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SchoolEdit(school_id: school_id);
  }
}

class SchoolEdit extends StatefulWidget {
  final int school_id;

  SchoolEdit({super.key, required this.school_id})
      : school = School.getSchool(school_id);

  final Future<School> school;

  @override
  State<StatefulWidget> createState() => _SchoolEditState();
}

class _SchoolEditState extends State<SchoolEdit> {
  bool name = false;
  bool address = false;
  bool board = false;

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final boardController = TextEditingController();
  Board? selectedBoard;

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder.single(
      widget.school,
      onData: (context, school) {
        return Form(
            key: _formKey,
            child: Column(
              children: [
                Row(children: [
                  Flexible(
                      child: TextFormField(
                          controller: nameController,
                          autofocus: true,
                          enabled: name,
                          validator: (value) {
                            if (!name) {
                              return null;
                            }
                            if (value?.isEmpty == null) {
                              return "Name is missing";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: "Enter School's name"))),
                  Checkbox(
                    value: name,
                    onChanged: (s) {
                      setState(() {
                        name = s ?? false;
                      });
                    },
                  )
                ]),
                Row(children: [
                  Flexible(
                      child: TextFormField(
                          controller: addressController,
                          autofocus: true,
                          enabled: address,
                          validator: (value) {
                            if (!address) {
                              return null;
                            }
                            if (value == null || value.isEmpty) {
                              return "Address is missing";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: "Enter School's Address"))),
                  Checkbox(
                    value: address,
                    onChanged: (s) {
                      setState(() {
                        address = s ?? false;
                      });
                    },
                  )
                ]),
                Row(children: [
                  Flexible(
                      child: FormField(
                    enabled: board,
                    validator: (value) {
                      if (!board) {
                        return null;
                      }
                      if (value == null) {
                        return "Board not selected";
                      }
                      return null;
                    },
                    builder: (field) {
                      return DropdownMenu<Board>(
                        initialSelection: null,
                        enabled: board,
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
                              label: board.toJson,
                              enabled: true,
                            );
                          })
                        ],
                      );
                    },
                  )),
                  Checkbox(
                    value: board,
                    onChanged: (s) {
                      setState(() {
                        board = s ?? false;
                      });
                    },
                  )
                ]),
                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();
                      await school.editSchool(
                          name ? nameController.text : null,
                          address ? addressController.text : null,
                          board ? selectedBoard : null);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Successfully updated school ${school.name}')),
                        );
                        const DashboardRoute().go(context);
                      }
                    }
                  },
                  child: const Text("Edit School"),
                )
              ],
            ));
      },
    );
  }
}
