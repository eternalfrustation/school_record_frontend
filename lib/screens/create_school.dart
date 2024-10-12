import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_record_frontend/services/user.dart';

class CreateMember extends StatefulWidget {
  final int? id;
  const CreateMember({super.key, this.id});

  @override
  State<StatefulWidget> createState() => _CreateMemberState();
}

class _CreateMemberState extends State<CreateMember> {
  final _formKey = GlobalKey<FormState>();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final dobController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Role? selectedRole;

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);
    final isSuperAdmin = userState.user?.role == Role.SUPER_ADMIN;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: fnameController,
            decoration: const InputDecoration(labelText: "First Name"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "First name is required";
              }
              return null;
            },
          ),
          TextFormField(
            controller: lnameController,
            decoration: const InputDecoration(labelText: "Last Name"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Last name is required";
              }
              return null;
            },
          ),
          TextFormField(
            controller: dobController,
            decoration: const InputDecoration(labelText: "Date of Birth"),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                setState(() {
                  dobController.text = formattedDate;
                });
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Date of birth is required";
              }
              return null;
            },
          ),
          TextFormField(
            controller: contactController,
            decoration: const InputDecoration(labelText: "Contact"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Contact is required";
              }
              return null;
            },
          ),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: "Email"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email is required";
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return "Enter a valid email";
              }
              return null;
            },
          ),
          TextFormField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: "Password"),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password is required";
              }
              if (value.length < 8) {
                return "Password must be at least 8 characters long";
              }
              return null;
            },
          ),
          DropdownButtonFormField<Role>(
            value: selectedRole,
            decoration: const InputDecoration(labelText: "Role"),
            items: Role.values
                .where((v) => v != Role.SUPER_ADMIN)
                .map((Role role) {
              return DropdownMenuItem<Role>(
                value: role,
                child: Text(role.toString().split('.').last),
              );
            }).toList(),
            onChanged: (Role? newValue) {
              setState(() {
                selectedRole = newValue;
              });
            },
            validator: (value) {
              if (value == null) {
                return "Role is required";
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final user = await userState.user?.addUser(
                  fname: fnameController.text,
                  lname: lnameController.text,
                  dob: DateTime.parse(dobController.text),
                  contact: contactController.text,
                  email: emailController.text,
                  role: selectedRole!,
                  school_id: isSuperAdmin
                      ? widget.id ?? userState.user!.school_id
                      : userState.user!.school_id,
                  password: passwordController.text,
                );
                if (user != null) {
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
            child: const Text("Add User"),
          ),
        ],
      ),
    );
  }
}
