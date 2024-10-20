import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_record_frontend/components/enum_dropdown.dart';
import 'package:school_record_frontend/components/search_table.dart';
import 'package:school_record_frontend/routes/dashboard.dart';
import 'package:school_record_frontend/routes/schools/users/create.dart';
import 'package:school_record_frontend/services/user.dart';

class UsersListRoute extends GoRouteData {
  final int? school_id;
  UsersListRoute({required this.school_id});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return UsersList(school_id: school_id);
  }
}

class UsersList extends StatefulWidget {
  final int? school_id;
  const UsersList({required this.school_id, super.key});

  @override
  createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  late Future<List<DataField>> defaultList;
  Role? role;

  @override
  void initState() {
    super.initState();
    defaultList = User.searchUsers(school_id: widget.school_id)
        .then((users) => users.map((user) => user.dataField).toList());
  }

  @override
  Widget build(BuildContext context) {
    return SearchTable(
      label: "Users",
      extraSearchWidgets: [
        EnumDropdownFormField<Role>(
            optionsList: Role.values,
            onChange: (role) {
              setState(() {
                this.role = role;
              });
            }),
        TextButton(
          child: const Text("Add User"),
          onPressed: () {
            UserCreateRoute(school_id: widget.school_id).go(context);
          },
        ),
      ],
      searchFunction: (name) =>
          User.searchUsers(school_id: widget.school_id, name: name, role: role)
              .then((users) => users.map((user) => user.dataField).toList()),
      defaultList: defaultList,
    );
  }
}
