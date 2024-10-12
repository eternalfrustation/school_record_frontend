import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

import '../services/user.dart';

class SchoolInfo extends StatelessWidget {
  final School school;
  const SchoolInfo({super.key, required this.school});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: [
      Row(children: [Text(school.name)]),
      Row(children: [const Text("Board: "), Text(school.board.toJson())]),
      Row(children: [const Text("Address: "), Text(school.address)]),
      Row(children: [
        const Text("Subscribed Since: "),
        Text(DateFormat.yMMMd().format(school.subscriptionStart))
      ]),
    ]));
  }
}

class SchoolRow extends StatelessWidget {
  final School school;
  const SchoolRow({super.key, required this.school});
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          context.go("/school?id=${school.id}");
        },
        child: Card(
            child: !school.photo
                ? Row(children: [
                    FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage, image: school.photoUrl),
                    SchoolInfo(school: school)
                  ])
                : SchoolInfo(school: school)));
  }
}
