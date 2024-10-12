import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../components/school_info.dart';
import '../../services/user.dart';
import '../components/user_info.dart';
import '../search_table.dart';

class Members extends StatefulWidget {
  const Members({super.key, this.id});
  final int? id;

  @override
  State<StatefulWidget> createState() => _MembersState();
}

class _MembersState extends State<Members> {
  final searchController = TextEditingController();
  List<User> users = [];

  final roleController = TextEditingController();
  Role selectedRole = Role.TEACHER;

  @override
  Widget build(BuildContext context) {
		return SearchTable(button: TextButton(
                  onPressed: () {
                    context.go("/create/member?id=${widget.id}");
                  },
                  child: const Text("Add User")),label: "Search users", defaultList: ,);
    return Consumer<UserState>(builder: (context, userState, child) {
      return Column(children: [
        const Text(),
        Row(children: [
          DropdownMenu<Role>(
            initialSelection: Role.TEACHER,
            controller: roleController,
            requestFocusOnTap: true,
            label: const Text('Role'),
            onSelected: (Role? role) {
              setState(() {
                if (role != null) {
                  selectedRole = role;
                }
              });
            },
            dropdownMenuEntries: [
              ...Role.values
                  .where((v) => v != Role.SUPER_ADMIN)
                  .map<DropdownMenuEntry<Role>>((Role role) {
                return DropdownMenuEntry<Role>(
                  value: role,
                  label: role.toString(),
                  enabled: true,
                );
              })
            ],
          ),
          Expanded(child: TextField(
            onChanged: (s) async {
              List<User> newUsers = await userState.user?.searchUser(s,
                      selectedRole, widget.id ?? userState.user!.school_id) ??
                  [];
              if (newUsers == users) {
                return;
              }
              setState(() {
                users = newUsers;
              });
            },
          )),
          SizedBox(
              width: 150,
              child: )
        ]),
        userState.user != null
            ? FutureBuilder<List<User>?>(
                future: userState.user!.searchUser(
                    "", selectedRole, widget.id ?? userState.user!.school_id),
                builder: (context, snapshot) {
                  return Column(
                      children: users.isEmpty
                          ? (snapshot.hasData
                              ? snapshot.data!
                                  .map((s) => UserRow(user: s))
                                  .toList()
                              : [])
                          : users.map((s) => UserRow(user: s)).toList());
                })
            : const CircularProgressIndicator()
      ]);
    });
  }
}
