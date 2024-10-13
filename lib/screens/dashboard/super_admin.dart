import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../components/search_table.dart';
import '../../services/user.dart';

class SuperAdminDashboard extends StatefulWidget {
  const SuperAdminDashboard({super.key});

  @override
  State<StatefulWidget> createState() => _SuperAdminDashboardState();
}

class _SuperAdminDashboardState extends State<SuperAdminDashboard> {
  final searchController = TextEditingController();
  List<School> schools = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(builder: (context, userState, child) {
      return SearchTable(
          button: TextButton(
              onPressed: () {
                context.go("/create/school");
              },
              child: const Text("Add School")),
          label: "Search schools",
          defaultList: userState.user!
              .getSchools()
              .then((s) => s?.map((d) => d.dataField).toList()),
          searchFunction: (s) => userState.user
              ?.searchSchool(s)
              .then((s) => s?.map((d) => d.dataField).toList()));
    });
  }
}
