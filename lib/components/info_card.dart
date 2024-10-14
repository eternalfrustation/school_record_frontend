import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'search_table.dart';

class InfoCard extends StatelessWidget {
  final DataField data;
  final List<TextButton>? buttons;

  List<Row> get firstTwo => data.data.entries
      .take(2)
      .map((s) => Row(children: [Text(s.key), Text(s.value)]))
      .toList();
  List<Row> get skipTwo => data.data.entries
      .skip(2)
      .map((s) => Row(children: [Text(s.key), Text(s.value)]))
      .toList();
  const InfoCard({super.key, required this.data, required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Wrap(children: [
      if (data.photo != null)
        FadeInImage.memoryNetwork(
            placeholder: kTransparentImage, image: data.photo!),
      Column(children: [
        if (data.title != null) Text(data.title!),
        if (data.subTitle != null) Text(data.subTitle!),
        ...firstTwo
      ]),
      ...skipTwo,
				if (buttons != null) Row(children: buttons!),
    ]));
  }
}
