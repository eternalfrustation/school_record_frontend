import 'package:flutter/material.dart';
import 'package:flutter_async_widgets/widgets/async_builder.dart';
import 'package:transparent_image/transparent_image.dart';

import 'search_table.dart';

class InfoCard extends StatelessWidget {
  final Future<DataField> data;
  final List<TextButton>? buttons;

  const InfoCard({super.key, required this.data, required this.buttons});

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder.single(data, onData: (context, data) {
      return Card(
          child: Wrap(children: [
        if (data.photo != null)
          FadeInImage.memoryNetwork(
              placeholder: kTransparentImage, image: data.photo!),
        Column(children: [
          if (data.title != null) Text(data.title!),
          if (data.subTitle != null) Text(data.subTitle!),
          ...data.data.entries
              .take(2)
              .map((s) => Row(children: [Text(s.key), Text(s.value)]))
        ]),
        ...data.data.entries
            .skip(2)
            .map((s) => Row(children: [Text(s.key), Text(s.value)])),
        if (buttons != null) Row(children: buttons!),
      ]));
    });
  }
}
