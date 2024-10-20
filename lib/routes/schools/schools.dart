// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_record_frontend/components/search_table.dart';
import 'package:school_record_frontend/routes/dashboard.dart';
import 'package:school_record_frontend/routes/schools/create.dart';
import 'package:school_record_frontend/services/school.dart';

class SchoolsListRoute extends GoRouteData {

  SchoolsListRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SchoolsList();
}

class SchoolsList extends StatelessWidget {
  const SchoolsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchTable(
        label: "Schools",
		extraSearchWidgets: [TextButton(child: const Text("Add School"), onPressed: () {
				SchoolCreateRoute().go(context);
			},)],
        searchFunction: (s) => School.searchSchools(s).then(
            (schools) => schools.map((school) => school.dataField).toList()),
        defaultList: School.listSchools().then(
            (schools) => schools.map((school) => school.dataField).toList()));
  }
}
