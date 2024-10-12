import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/user.dart';

class ClassroomInfo extends StatelessWidget {
  final Classroom classroom;
  const ClassroomInfo({super.key, required this.classroom});

  @override
  Widget build(BuildContext context) {
    return Card(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(
        children: [
          Row(children: [
            const Text("Standard: "),
            Text(classroom.standard.toString().split('.').last)
          ]),
          Row(children: [const Text("Section: "), Text(classroom.section)]),
        ],
      ),
      FloatingActionButton(
        backgroundColor: Colors.green.shade800,
        onPressed: () {
          String url = "https://wa.me/+923045873730/?text=Hello";
          launchUrl(Uri.parse(url));
        },
        child: const FaIcon(FontAwesomeIcons.whatsapp),
      ),
    ]));
  }
}

class ClassroomRow extends StatelessWidget {
  final Classroom classroom;
  const ClassroomRow({super.key, required this.classroom});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.go("/classroom?id=${classroom.id}");
      },
      child: Card(
        child: ClassroomInfo(classroom: classroom),
      ),
    );
  }
}
