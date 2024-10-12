import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

import '../services/user.dart';

class UserInfo extends StatelessWidget {
  final User user;
  const UserInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Text('${user.fname} ${user.lname}')]),
          Row(children: [
            const Text("Role: "),
            Text(user.role.toString().split('.').last)
          ]),
          Row(children: [const Text("Email: "), Text(user.email)]),
          Row(children: [const Text("Contact: "), Text(user.contact)]),
          Row(children: [
            const Text("Date of Birth: "),
            Text(DateFormat.yMMMd().format(user.dob))
          ]),
        ],
      ),
    );
  }
}

class UserRow extends StatelessWidget {
  final User user;
  const UserRow({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.go("/user?id=${user.id}");
      },
      child: Card(
        child: user.photo
            ? Row(
                children: [
                  FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: user.photoUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: UserInfo(user: user))
                ],
              )
            : UserInfo(user: user),
      ),
    );
  }
}
