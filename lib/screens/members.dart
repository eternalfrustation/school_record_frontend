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
    return Consumer<UserState>(builder: (context, userState, child) {
      return SearchTable(
          button: TextButton(
              onPressed: () {
                context.go("/create/member?id=${widget.id}");
              },
              child: const Text("Add User")),
          label: "Search users",
          defaultList: userState.user!
              .searchUser(
                  "", selectedRole, widget.id ?? userState.user!.school_id)
              .then((u) => u?.map((s) => s.dataField).toList()),
          searchFunction: (s) => userState.user
              ?.searchUser(
                  s, selectedRole, widget.id ?? userState.user!.school_id)
              .then((u) => u?.map((s) => s.dataField).toList()));
    });
  }
}
