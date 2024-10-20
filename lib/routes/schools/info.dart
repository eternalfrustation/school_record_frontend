import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_record_frontend/components/delete_dialog.dart';
import 'package:school_record_frontend/components/info_card.dart';
import 'package:school_record_frontend/routes/dashboard.dart';
import 'package:school_record_frontend/routes/schools/edit.dart';
import 'package:school_record_frontend/services/school.dart';

class SchoolInfoRoute extends GoRouteData {
  final int school_id;

  SchoolInfoRoute({required this.school_id});

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SchoolInfo(school_id: school_id);
}

class SchoolInfo extends StatelessWidget {
  final int school_id;

  SchoolInfo({super.key, required this.school_id})
      : school = School.getSchool(school_id);

  final Future<School> school;
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      data: school.then((school) => school.dataField),
      buttons: [
        TextButton(
          child: const Text("Edit"),
          onPressed: () {
            SchoolEditRoute(school_id: school_id).go(context);
          },
        ),
        TextButton(
            child: const Text("Delete"),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => deleteDialog(context, "", () {
                        return school.then((school) {
                          school.deleteSchool();
                        });
                      }));
            })
      ],
    );
  }
}
