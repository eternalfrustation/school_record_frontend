// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:convert';

import 'package:school_record_frontend/components/search_table.dart';
import 'package:school_record_frontend/main.dart';
import 'package:school_record_frontend/routes/dashboard.dart';
import 'package:school_record_frontend/routes/schools/info.dart';

class School {
  final int id;
  final String name;
  final String address;
  final Board board;
  final DateTime subscription_start;
  final bool photo;

  School(
      {required this.id,
      required this.name,
      required this.address,
      required this.board,
      required this.subscription_start,
      required this.photo});

  String? get photoUrl {
    if (photo) {
      return "$baseUrl/schools/photo/$id";
    }
    return null;
  }

  DataField get dataField => DataField(
          title: name,
          photo: photoUrl,
          link: SchoolInfoRoute(school_id: id).location,
          subTitle: name,
          data: {
            "Address": address,
            "Subscribed Since": subscription_start.toString(),
          });

  static Future<List<School>> listSchools() async {
    final resp = await webClient.get(Uri.parse("$baseUrl/schools"));
    if (resp.statusCode != 200) {
      return Future.error("Not Authenticated");
    }
    final jsonDecoded = json.decode(resp.body) as List<Map<String, dynamic>>;
    return jsonDecoded.map((v) => School.fromJson(v)).toList();
  }

  static Future<List<School>> searchSchools(String name) async {
    final resp =
        await webClient.get(Uri.parse("$baseUrl/search/schools?name=$name"));
    if (resp.statusCode != 200) {
      return Future.error("Not Authenticated");
    }
    final jsonDecoded = json.decode(resp.body) as List<dynamic>;
    final schools = jsonDecoded.map((v) => School.fromJson(v)).toList();
    return schools;
  }

  static Future<School> addSchool(
      String name, String address, Board board) async {
    try {
      final resp = await webClient.post(Uri.parse("$baseUrl/schools"),
          body: {"name": name, "address": address, "board": board.toJson});
      if (resp.statusCode == 401) {
        return Future.error("Unauthorized");
      }
      if (resp.statusCode != 200) {
        return Future.error("Unknown Error");
      }
      return School.fromJson(json.decode(resp.body));
    } catch (e) {
      print(e);
      return Future.error("Unknown Error");
    }
  }

  static Future<School> getSchool(int id) async {
    final resp = await webClient.get(Uri.parse("$baseUrl/schools/$id"));
    if (resp.statusCode != 200) {
      return Future.error("Not Found");
    }
    return School.fromJson(json.decode(resp.body));
  }

  Future<School> editSchool(String? name, String? address, Board? board) async {
    final body = {
      "id": id.toString(),
    };
    if (name != null) {
      body["name"] = name;
    }
    if (address != null) {
      body["address"] = address;
    }
    if (board != null) {
      body["board"] = board.toJson;
    }
    final resp = await webClient.patch(Uri.parse("$baseUrl/schools"), body: body);
    if (resp.statusCode == 401) {
      return Future.error("Unauthorized");
    }
    if (resp.statusCode != 200) {
      return Future.error("Unknown Error");
    }
    return School.fromJson(json.decode(resp.body));
  }

  Future<School> deleteSchool() async {
    final resp = await webClient.delete(
      Uri.parse("$baseUrl/schools?id=$id"),
    );
    if (resp.statusCode == 401) {
      return Future.error("Unauthorized");
    }
    if (resp.statusCode != 200) {
      return Future.error("Unknown Error");
    }
    return School.fromJson(json.decode(resp.body));
  }

  School.fromJson(Map<String, dynamic> json)
      : id = json["id"] as int,
        name = json["name"] as String,
        address = json["address"] as String,
        board = Board.fromJson(json["board"]),
        subscription_start = DateTime.parse(json["subscription_start"]),
        photo = json["photo"] as bool;
}

enum Board {
  CBSE,
  CICSE,
  NIOS,
  STATE;

  String get toJson => name;

  factory Board.fromJson(String s) =>
      Board.values.where((v) => v.name == s).first;
}
