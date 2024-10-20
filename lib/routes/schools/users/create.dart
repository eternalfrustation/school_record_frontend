import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_record_frontend/components/enum_dropdown.dart';
import 'package:school_record_frontend/services/user.dart';

class UserCreateRoute extends GoRouteData {
  final int? school_id;
  UserCreateRoute({required this.school_id});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return UserCreate(school_id: school_id);
  }
}

class UserCreate extends StatefulWidget {
  final int? school_id;
  const UserCreate({required this.school_id, super.key});

  @override
  createState() => _UserCreateState();
}

class _UserCreateState extends State<UserCreate> {
  final _formKey = GlobalKey<FormState>();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final dobController = TextEditingController();
  DateTime selectedDob = DateTime.now();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Role? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
                controller: fnameController,
                autofocus: true,
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return "First Name is missing";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "First Name",
                    hintText: "Enter the first name of the user")),
            TextFormField(
                controller: lnameController,
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return "Last Name is missing";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "Last Name",
                    hintText: "Enter the last name of the user")),
            TextFormField(
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
                    return "Contact is missing";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "Contact",
                    hintText: "Enter the contact of the user")),
            TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return "Email is missing";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "Email",
                    hintText: "Enter the email of the user")),
            TextFormField(
                controller: passwordController,
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return "Password is missing";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "Password",
                    hintText: "Enter the password of the user")),
            EnumDropdownFormField<Role>(
                optionsList: Role.values,
                onChange: (role) {
                  setState(() {
                    selectedRole = role;
                  });
                }),
            ElevatedButton(
                child: const Text("Create User"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    User.createUser(
                        school_id: widget.school_id ?? 0,
                        fname: fnameController.text,
                        lname: lnameController.text,
                        dob: selectedDob,
                        contact: contactController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        role: selectedRole ?? Role.STUDENT);
                  }
                })
          ],
        ));
  }
}
