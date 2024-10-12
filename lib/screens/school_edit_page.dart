import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_record_frontend/services/user.dart';

class SchoolEditPage extends StatefulWidget {
  final int? id;
  const SchoolEditPage({super.key, this.id});

  @override
  State<StatefulWidget> createState() => _SchoolEditPageState();
}

class _SchoolEditPageState extends State<SchoolEditPage>
    with AfterLayoutMixin<SchoolEditPage> {
  Future<School?>? schoolFuture;
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    setState(() {
      schoolFuture = Provider.of<UserState>(context, listen: false)
          .user
          ?.getSchool(widget.id)
          .then((v) {
        if (v != null) {
          nameController.text = v.name;
          addressController.text = v.address;
          boardController.text = v.board.toJson();
        }

        return v;
      });
    });
  }

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
    return FutureBuilder(
      future: schoolFuture,
      builder: (context, snapshot) {
        final school = snapshot.data;
        return school != null
            ? Form(
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
                                  label: board.toJson(),
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
                    Consumer<UserState>(builder: (context, userState, child) {
                      return TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState?.save();
                            final user = userState.user;
                            if (user != null) {
                              final school = await user.updateSchool(
                                  id: widget.id ?? user.school_id,
                                  name: name ? nameController.text : null,
                                  address:
                                      address ? addressController.text : null,
                                  board: board ? selectedBoard : null);
                              print(school.toString());
                              if (school != null) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Successfully updated school ${school.name}')),
                                  );
                                  context.go("/dashboard");
                                }
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Network Error')),
                                  );
                                }
                              }
                            }
                          } 
                        },
                        child: const Text("Edit School"),
                      );
                    })
                  ],
                ))
            : const CircularProgressIndicator();
      },
    );
  }
}
