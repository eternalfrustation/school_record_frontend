import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/user.dart';
import '../components/enum_dropdown.dart';
import '../components/search_table.dart';

class Users extends StatefulWidget {
  const Users({super.key, this.id});
  final int? id;

  @override
  State<StatefulWidget> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final searchController = TextEditingController();
  List<User> users = [];

  final roleController = TextEditingController();
  Role? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(builder: (context, userState, child) {
      final user = userState.user!;
      return SearchTable(
          label: "Search users",
          extraSearchWidgets: [
            Expanded(
                child: EnumDropdownFormField<Role>(
              onChange: (v) {
                setState(() {
                  selectedRole = v;
                });
              },
              optionsList:
                  Role.values.where((v) => v != Role.SUPER_ADMIN).toList(),
            )),
            SizedBox(
                width: 150,
                child: TextButton(
                    onPressed: () {
                      context.go("/create/member?id=${widget.id}");
                    },
                    child: const Text("Add User")))
          ],
          defaultList: user
              .searchUser("", selectedRole ?? user.role,
                  widget.id ?? userState.user!.school_id)
              .then((u) => u?.map((s) => s.dataField).toList()),
          searchFunction: (s) => userState.user
              ?.searchUser(s, selectedRole ?? user.role,
                  widget.id ?? userState.user!.school_id)
              .then((u) => u?.map((s) => s.dataField).toList()));
    });
  }
}
