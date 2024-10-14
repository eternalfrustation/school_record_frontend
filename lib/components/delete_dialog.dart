import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/user.dart';

Widget deleteDialog(
    BuildContext context, String name, Future? Function() onClick) {
  return AlertDialog(
    title: Text("Delete $name?"),
    content: Text("Are you sure that you want to delete $name"),
    actions: [
      TextButton(
        child: const Text("Cancel"),
        onPressed: () {
          context.pop();
        },
      ),
      Consumer<UserState>(
        builder: (context, userState, child) {
          return TextButton(
            child: const Text("Delete"),
            onPressed: () async {
              final result = onClick();
              if (result != null) {
                await result;
              }

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Successfully deleted school $name')),
                );
                context.pop();
              }
            },
          );
        },
      )
    ],
  );
}
