// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:school_record_frontend/components/search_table.dart';
import 'package:school_record_frontend/main.dart';
import 'package:school_record_frontend/routes/dashboard.dart';
import 'package:school_record_frontend/routes/schools/users/info.dart';

class User {
  final int id;
  final String fname;
  final String lname;
  final DateTime dob;
  final String contact;
  final String email;
  final Role role;
  final int school_id;
  final bool photo;

  User(
      {required this.id,
      required this.fname,
      required this.lname,
      required this.dob,
      required this.contact,
      required this.email,
      required this.role,
      required this.school_id,
      required this.photo});

  static Future<User> currentUser() async {
    var resp = await webClient.get(
      Uri.parse("$baseUrl/user"),
    );
    if (resp.statusCode != 200) {
      return Future.error("User not logged in");
    }
    return User.fromJson(json.decode(resp.body));
  }

  static Future<User> signIn(String email, String password) async {
    var resp = await webClient.post(Uri.parse("$baseUrl/auth"),
        body: {"email": email, "password": password});
    print(resp.statusCode);
    if (resp.statusCode != 200) {
      return Future.error(Exception("Incorrect Email or password"));
    }
		final dataMap = json.decode(resp.body);
		print(dataMap);
    return User.fromJson(dataMap);
  }

  static Future<User> getUser(int? id) async {
    var resp = await webClient.get(
      Uri.parse("$baseUrl/user"),
    );
    if (resp.statusCode != 200) {
      return Future.error("Error fetching user");
    }
    return User.fromJson(json.decode(resp.body));
  }

  User.fromJson(Map<String, dynamic> json)
      : id = json["id"] as int,
        fname = json["fname"] as String,
        lname = json["lname"] as String,
        dob = DateTime.parse(json["dob"]),
        contact = json["contact"] as String,
        email = json["email"] as String,
        role = Role.fromJson(json["role"]),
        school_id = json["school_id"] as int,
        photo = json["photo"] as bool;
  String get name => "$fname $lname";
  String? get photoUrl {
    if (photo) {
      return "$baseUrl/user/photo/$id";
    }
    return null;
  }

  static Future<User> createUser(
      {required String fname,
      required String lname,
      required DateTime dob,
      required String contact,
      required String email,
      required String password,
      required Role role,
      required int school_id}) async {
    var resp = await webClient.post(
      Uri.parse("$baseUrl/user"),
      body: json.encode({
        "fname": fname,
        "lname": lname,
        "dob": dob,
        "contact": contact,
        "email": email,
        "role": role,
        "school_id": school_id,
      }),
    );
    if (resp.statusCode != 200) {
      return Future.error("Error creating user");
    }
    return User.fromJson(json.decode(resp.body));
  }

  static Future<List<User>> searchUsers(
      {int? school_id, Role? role, String? name}) async {
    final searchUri = Uri.parse("$baseUrl/search/user");
    searchUri.queryParametersAll.addEntries([
      if (school_id != null) MapEntry("school_id", [school_id.toString()]),
      if (role != null) MapEntry("role", [role.toJson]),
      if (name != null) MapEntry("name", [name]),
    ]);
    var resp = await webClient.get(
      searchUri,
    );
    if (resp.statusCode != 200) {
      return Future.error("Error fetching users");
    }
    return (json.decode(resp.body) as List)
        .map((e) => User.fromJson(e))
        .toList();
  }

  Future<User> editUser({
    String? fname,
    String? lname,
    DateTime? dob,
    String? contact,
    String? email,
  }) async {
    var resp = await webClient.patch(
      Uri.parse("$baseUrl/user&id=$id"),
      body: json.encode({
        "fname": fname ?? this.fname,
        "lname": lname ?? this.lname,
        "dob": dob ?? this.dob,
        "contact": contact ?? this.contact,
        "email": email ?? this.email,
      }),
    );
    if (resp.statusCode != 200) {
      return Future.error("Error editing user");
    }
    return User.fromJson(json.decode(resp.body));
  }

  Future<User> deleteUser() async {
    var resp = await webClient.delete(
      Uri.parse("$baseUrl/user&id=$id"),
    );
    if (resp.statusCode != 200) {
      return Future.error("Error deleting user");
    }
    return this;
  }

  DataField get dataField => DataField(
      title: name,
      photo: photoUrl,
      link: UserInfoRoute(user_id: id).location,
      subTitle: role.name,
      data: {"E-Mail": email, "Contact No.": contact});

  Map<String, dynamic> toJson() => {
        "id": id,
        "fname": fname,
        "lname": lname,
        "dob": dob,
        "contact": contact,
        "email": email,
        "role": role,
        "school_id": school_id,
        "photo": photo,
      };
}

enum Role {
  STUDENT,
  TEACHER,
  SCHOOL_ADMIN,
  PRINCIPAL,
  SUPER_ADMIN;

  String get toJson => name;

  factory Role.fromJson(String s) =>
      Role.values.where((v) => v.name == s).first;
}
