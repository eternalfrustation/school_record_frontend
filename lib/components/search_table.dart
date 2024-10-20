
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transparent_image/transparent_image.dart';

class SearchTable extends StatefulWidget {
  final Future<List<DataField>?>? Function(String) searchFunction;
  final Future<List<DataField>?>? defaultList;
  final List<Widget>? extraSearchWidgets;
  final String? label;
  const SearchTable(
      {super.key,
      required this.searchFunction,
      required this.defaultList,
      required this.label,
      this.extraSearchWidgets});

  @override
  State<StatefulWidget> createState() => _SearchTableState();
}

class _SearchTableState extends State<SearchTable> {
  List<DataField> results = [];
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (widget.label != null) Text(widget.label!),
      Row(children: [
        Expanded(child: TextField(
          onChanged: (s) async {
            List<DataField> newResults = await widget.searchFunction(s) ?? [];
            if (newResults == results) {
              return;
            }
            setState(() {
              results = newResults;
            });
          },
        )),
        if (widget.extraSearchWidgets != null) ...widget.extraSearchWidgets!,
      ]),
      FutureBuilder<List<DataField>?>(
          future: widget.defaultList,
          builder: (context, snapshot) {
            return Column(
                children: results.isEmpty
                    ? (snapshot.hasData
                        ? snapshot.data!.map((s) => DataRow(data: s)).toList()
                        : [])
                    : results.map((s) => DataRow(data: s)).toList());
          })
    ]);
  }
}

class DataField {
  final String? title;
  final String? subTitle;
  final String? photo;
  final String? link;
  final Map<String, String> data;

  DataField(
      {this.subTitle, this.title, this.photo, this.link, required this.data});
}

class DataInfo extends StatelessWidget {
  final Map<String, String> data;

  const DataInfo({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
            children: data.entries
                .map((entry) =>
                    Row(children: [Text(entry.key), Text(entry.value)]))
                .toList()));
  }
}

class DataRow extends StatelessWidget {
  final DataField data;

  const DataRow({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: data.link != null
            ? () {
				context.go(data.link!);
              }
            : null,
        child: Card(
            child: Row(children: [
          if (data.photo != null)
            FadeInImage.memoryNetwork(
                placeholder: kTransparentImage, image: data.photo!),
          Column(children: [
            if (data.title != null) Text(data.title!),
            if (data.subTitle != null) Text(data.subTitle!),
            DataInfo(data: data.data)
          ])
        ])));
  }
}
