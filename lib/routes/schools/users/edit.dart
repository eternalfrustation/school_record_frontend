import 'package:flutter/material.dart';
import 'package:flutter_async_widgets/widgets/async_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:school_record_frontend/services/user.dart';

class UserEditRoute extends GoRouteData {
  final int? user_id;
  UserEditRoute({this.user_id});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return UserEdit(id: user_id);
  }
}

class UserEdit extends StatefulWidget {
  final int? id;

  const UserEdit({super.key, this.id});
  @override
  createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  bool fname = false;
  bool lname = false;
  bool email = false;
  bool role = false;
  bool contact = false;
  bool dob = false;

  late Future<User> userFuture;
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final dobController = TextEditingController();

  DateTime selectedDob = DateTime.now();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    userFuture = User.getUser(widget.id);
    return AsyncBuilder.single(userFuture, onData: (context, user) {
      return Form(
          key: _formKey,
          child: Column(children: [
            Row(children: [
              Flexible(
                child: TextFormField(
                    controller: fnameController,
                    autofocus: true,
                    enabled: fname,
                    validator: (value) {
                      if (!fname) {
                        return null;
                      }
                      if (value?.isEmpty == null) {
                        return "First name is missing";
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(labelText: "Enter First Name")),
              ),
              Checkbox(
                value: fname,
                onChanged: (s) {
                  setState(() {
                    fname = s ?? false;
                  });
                },
              )
            ]),
            Row(children: [
              Flexible(
                child: TextFormField(
                    controller: lnameController,
                    autofocus: true,
                    enabled: lname,
                    validator: (value) {
                      if (!lname) {
                        return null;
                      }
                      if (value == null || value.isEmpty) {
                        return "Last name is missing";
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(labelText: "Enter Last Name")),
              ),
              Checkbox(
                value: lname,
                onChanged: (s) {
                  setState(() {
                    lname = s ?? false;
                  });
                },
              )
            ]),
            Row(children: [
              Flexible(
                child: TextFormField(
                    enabled: dob,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      ).then((value) {
                        if (value != null) {
                          selectedDob = value;
                          dobController.text = value.toString();
                        }
                      });
                    },
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return "DoB is missing";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        labelText: "Date of Birth",
                        hintText: "Enter the Date of Birth of the user")),
              ),
              Checkbox(
                value: dob,
                onChanged: (s) {
                  setState(() {
                    dob = s ?? false;
                  });
                },
              )
            ]),
            Row(children: [
              Flexible(
                child: TextFormField(
                    controller: emailController,
                    autofocus: true,
                    enabled: email,
                    validator: (value) {
                      if (!email) {
                        return null;
                      }
                      if (value == null || value.isEmpty) {
                        return "Email is missing";
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(labelText: "Enter Email")),
              ),
              Checkbox(
                value: email,
                onChanged: (s) {
                  setState(() {
                    email = s ?? false;
                  });
                },
              )
            ]),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState?.save();
                  user.editUser(
                      fname: fname ? fnameController.text : null,
                      lname: lname ? lnameController.text : null,
                      email: email ? emailController.text : null,
                      dob: dob ? selectedDob : null,
                      contact: contact ? contactController.text : null);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Successfully updated user ${user.name}')),
                    );
                    context.go("/");
                  }
                }
              },
              child: const Text("Edit User"),
            )
          ]));
    });
  }
}
