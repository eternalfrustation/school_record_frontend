// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:intl/intl.dart';

import '../components/search_table.dart';

final webClient = BrowserClient()..withCredentials = true;

const baseUrl = "http://localhost:3000";

Future<User?> getUserProfile() async {
  return webClient.get(Uri.parse("$baseUrl/user")).then(
      (e) => e.statusCode == 200 ? User.fromJson(json.decode(e.body)) : null);
}

class UserState extends ChangeNotifier {
  User? _user;
  User? get user => _user;

  Future<void> syncWithBackend() async {
    var resp = await webClient.get(Uri.parse("$baseUrl/user"));
    if (resp.statusCode == 200) {
      final user = User.fromJson(json.decode(resp.body));
      if (user != _user) {
        _user = user;
        notifyListeners();
      }
    }
  }

  Future<bool> signIn(String username, String password) async {
    var resp = await webClient.post(Uri.parse("$baseUrl/auth"),
        body: {"email": username, "password": password});
    if (resp.statusCode != 200) {
      return false;
    }
    final user = User.fromJson(json.decode(resp.body));
    if (user != _user) {
      _user = user;
      notifyListeners();
    }
    return true;
  }
}

class School {
  int id;
  String name;
  String address;
  Board board;
  DateTime subscriptionStart;
  bool photo;

  School({
    required this.id,
    required this.name,
    required this.address,
    required this.board,
    required this.subscriptionStart,
    required this.photo,
  });

  String get photoUrl => "$baseUrl/schools/photo/$id";

  // Factory method to create School instance from JSON
  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      board: BoardExtension.fromJson(json['board']),
      subscriptionStart: DateTime.parse(json['subscription_start']),
      photo: json['photo'] != null,
    );
  }
  DataField get dataField => DataField(
          title: name,
          photo: photo ? null : photoUrl,
          link: "/school?id=$id",
          data: {
            "Board: ": board.toJson(),
            'Subscribed Since: ': DateFormat.yMMMd().format(subscriptionStart),
            "Address: ": address,
          });

  // Method to convert School instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'board': board.toJson(),
      'subscription_start': subscriptionStart.toIso8601String(),
      'photo': photo ? 'true' : null,
    };
  }
}

enum Board {
  CBSE,
  CICSE,
  NIOS,
  STATE,
}

extension BoardExtension on Board {
  // Convert Board enum to string for JSON
  String toJson() {
    switch (this) {
      case Board.CBSE:
        return 'CBSE';
      case Board.CICSE:
        return 'CICSE';
      case Board.NIOS:
        return 'NIOS';
      case Board.STATE:
        return 'STATE';
      default:
        throw Exception('Invalid board');
    }
  }

  // Convert string to Board enum
  static Board fromJson(String json) {
    switch (json) {
      case 'CBSE':
        return Board.CBSE;
      case 'CICSE':
        return Board.CICSE;
      case 'NIOS':
        return Board.NIOS;
      case 'STATE':
        return Board.STATE;
      default:
        throw Exception('Unknown board: $json');
    }
  }
}

enum Role {
  SUPER_ADMIN,
  PRINCIPAL,
  SCHOOL_ADMIN,
  TEACHER,
  STUDENT;

  static const List<Role> VARIANTS = [
    SUPER_ADMIN,
    PRINCIPAL,
    SCHOOL_ADMIN,
    TEACHER,
    STUDENT,
  ];

  int get value {
    switch (this) {
      case SUPER_ADMIN:
        return 0;
      case PRINCIPAL:
        return -1;
      case SCHOOL_ADMIN:
        return -2;
      case TEACHER:
        return -3;
      case STUDENT:
        return -4;
    }
  }

  static Role fromValue(String value) {
    switch (value) {
      case "SUPER_ADMIN":
        return SUPER_ADMIN;
      case "PRINCIPAL":
        return PRINCIPAL;
      case "SCHOOL_ADMIN":
        return SCHOOL_ADMIN;
      case "TEACHER":
        return TEACHER;
      case "STUDENT":
        return STUDENT;
      default:
        throw ArgumentError('Invalid Role value: $value');
    }
  }

  @override
  String toString() => name.toUpperCase();
}

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

  User({
    required this.id,
    required this.fname,
    required this.lname,
    required this.dob,
    required this.contact,
    required this.email,
    required this.role,
    required this.school_id,
    required this.photo,
  });
  String get name => "$fname $lname";
  String get photoUrl => "$baseUrl/users/photo/$id";

  DataField get dataField => DataField(
          title: name,
          subTitle: role.toString(),
          photo: photo ? null : photoUrl,
          link: "/user?id=$id",
          data: {
            "Date Of Birth: ": DateFormat.yMMMd().format(dob),
            'Contact: ': contact,
            "E-Mail: ": email,
          });
  Future<List<User>?> searchUser(String name, Role role, int schoolId) async {
    var resp = await webClient.get(Uri.parse(
        "$baseUrl/search/user?name=$name&school_id=$schoolId&role=${role.toString()}"));
    if (resp.statusCode != 200) {
      return null;
    }
    List<dynamic> users = json.decode(resp.body);
    return users.map((e) => User.fromJson(e)).toList();
  }

  Future<User?> getUser(int? id) async {
    var resp = await webClient.get(Uri.parse("$baseUrl/user?id=$id"));
    if (resp.statusCode != 200) {
      return null;
    }
    return User.fromJson(json.decode(resp.body));
  }

  Future<School?> deleteUser(int id) async {
    final resp = await webClient.delete(
      Uri.parse("$baseUrl/user?id=$id"),
    );
    if (resp.statusCode == 200) {
      final school = School.fromJson(json.decode(resp.body));
      return school;
    }
    return null;
  }

  Future<User?> addUser({
    required String fname,
    required String lname,
    required DateTime dob,
    required String contact,
    required String email,
    required Role role,
    required int school_id,
    required String password,
  }) async {
    // Use intl package to format the date as YYYY-MM-DD
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDob = formatter.format(dob);

    final resp = await webClient.post(
      Uri.parse("$baseUrl/user"),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        "fname": fname,
        "lname": lname,
        "dob": formattedDob,
        "contact": contact,
        "email": email,
        "role": role.toString(),
        "school_id": school_id.toString(),
        "password": password,
      },
    );

    if (resp.statusCode == 200) {
      final user = User.fromJson(json.decode(resp.body));
      return user;
    }
    return null;
  }

  Future<School?> addSchool(String name, String address, Board board) async {
    final resp = await webClient.post(
      Uri.parse("$baseUrl/schools"),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {"name": name, "address": address, "board": board.toJson()},
    );
    if (resp.statusCode == 200) {
      final school = School.fromJson(json.decode(resp.body));
      return school;
    }
    return null;
  }

  Future<School?> getSchool(int? id) async {
    final resp = await webClient.get(
      Uri.parse("$baseUrl/schools/${id ?? school_id}"),
    );
    if (resp.statusCode == 200) {
      final school = School.fromJson(json.decode(resp.body));
      return school;
    }
    return null;
  }

  Future<School?> deleteSchool(int id) async {
    final resp = await webClient.delete(
      Uri.parse("$baseUrl/schools?id=$id"),
    );
    if (resp.statusCode == 200) {
      final school = School.fromJson(json.decode(resp.body));
      return school;
    }
    return null;
  }

  Future<List<School>?> searchSchool(String name) async {
    var resp =
        await webClient.get(Uri.parse("$baseUrl/search/schools?name=$name"));
    if (resp.statusCode != 200) {
      return null;
    }
    List<dynamic> schools = json.decode(resp.body);
    return schools.map((e) => School.fromJson(e)).toList();
  }

  Future<List<School>?> getSchools() async {
    var resp = await webClient.get(Uri.parse("$baseUrl/schools"));
    if (resp.statusCode != 200) {
      return null;
    }
    List<dynamic> schools = json.decode(resp.body);
    return schools.map((e) => School.fromJson(e)).toList();
  }

  Future<School?> updateSchool(
      {required int id, String? name, String? address, Board? board}) async {
    Map<String, String> patchBody = {};
    if (name != null) {
      patchBody["name"] = name;
    }
    if (address != null) {
      patchBody["address"] = address;
    }
    if (board != null) {
      patchBody["board"] = board.toJson();
    }
    patchBody["id"] = id.toString();
    final resp = await webClient.patch(
      Uri.parse("$baseUrl/schools"),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: patchBody,
    );
    if (resp.statusCode == 200) {
      final school = School.fromJson(json.decode(resp.body));
      return school;
    }
    return null;
  }

  Future<List<Classroom>?> searchClassroom({
    required int? schoolId,
    String? section,
    Standard? standard,
  }) async {
    String query = "$baseUrl/classrooms?school_id=$schoolId&";

    // Add section to query if it's not null
    if (section != null) {
      query += "section=$section&";
    }

    // Add standard to query if it's not null
    if (standard != null) {
      query += "standard=${standard.toJson()}&";
    }

    var resp = await webClient.get(Uri.parse(query));

    if (resp.statusCode != 200) {
      return null;
    }

    List<dynamic> classrooms = json.decode(resp.body);
    return classrooms.map((e) => Classroom.fromJson(e)).toList();
  }

  // Get classroom by ID
  Future<Classroom?> getClassroom(int id) async {
    var resp = await webClient.get(Uri.parse("$baseUrl/classrooms/$id"));
    if (resp.statusCode != 200) {
      return null;
    }
    return Classroom.fromJson(json.decode(resp.body));
  }

  // Add a new classroom
  Future<Classroom?> addClassroom({
    required String section,
    required Standard standard,
    required String whatsappLink,
    required int schoolId,
  }) async {
    final resp = await webClient.post(
      Uri.parse("$baseUrl/classrooms"),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        "section": section,
        "standard": standard.toJson(),
        "school_id": schoolId.toString(),
        "whatsapp_link": whatsappLink.toString(),
      },
    );

    if (resp.statusCode == 200) {
      final classroom = Classroom.fromJson(json.decode(resp.body));
      return classroom;
    }
    return null;
  }

  Future<Classroom?> updateClassroom({
    required int id,
    String? section,
    Standard? standard,
    int? schoolId,
  }) async {
    // Prepare the data for the request
    Map<String, String> body = {};

    if (section != null) body['section'] = section;
    if (standard != null) body['standard'] = standard.toJson();
    if (schoolId != null) body['school_id'] = schoolId.toString();

    final resp = await webClient.patch(
      Uri.parse("$baseUrl/classrooms?id=$id"),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );

    if (resp.statusCode == 200) {
      return Classroom.fromJson(json.decode(resp.body));
    }

    return null;
  }

  // Delete a classroom by ID
  Future<School?> deleteClassroom(int id) async {
    final resp = await webClient.delete(
      Uri.parse("$baseUrl/classrooms?id=$id"),
    );
    if (resp.statusCode == 200) {
      final school = School.fromJson(json.decode(resp.body));
      return school;
    }
    return null;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fname: json['fname'],
      lname: json['lname'],
      dob: DateTime.parse(json['dob']),
      contact: json['contact'],
      email: json['email'],
      role: Role.fromValue(json['role']),
      school_id: json['school_id'],
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fname': fname,
      'lname': lname,
      'dob': dob.toIso8601String(),
      'contact': contact,
      'email': email,
      'role': role.value,
      'school_id': school_id,
      'photo': photo,
    };
  }
}

class Classroom {
  int id;
  String section;
  Standard standard;
  bool photo;
  int schoolId;

  Classroom({
    required this.id,
    required this.section,
    required this.standard,
    required this.schoolId,
    required this.photo,
  });

  String get photoUrl => "$baseUrl/classroom/photo/$id";

  DataField get dataField => DataField(
      title: standard.name,
      subTitle: section,
      photo: photo ? photoUrl : null,
      link: "/classroom?id=$id",
      data: {});
  // Factory method to create Classroom instance from JSON
  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      id: json['id'],
      section: json['section'],
      standard: StandardExtension.fromJson(json['standard']),
      photo: json['photo'],
      schoolId: json['school_id'],
    );
  }

  // Method to convert Classroom instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'section': section,
      'standard': standard.toJson(),
      'school_id': schoolId,
    };
  }
}

enum Standard {
  LKG,
  UKG,
  FIRST,
  SECOND,
  THIRD,
  FOURTH,
  FIFTH,
  SIXTH,
  SEVENTH,
  EIGHTH,
  NINTH,
  TENTH,
  ELEVENTH,
  TWELFTH,
}

extension StandardExtension on Standard {
  // Convert Standard enum to string for JSON
  String toJson() {
    switch (this) {
      case Standard.LKG:
        return 'LKG';
      case Standard.UKG:
        return 'UKG';
      case Standard.FIRST:
        return 'FIRST';
      case Standard.SECOND:
        return 'SECOND';
      case Standard.THIRD:
        return 'THIRD';
      case Standard.FOURTH:
        return 'FOURTH';
      case Standard.FIFTH:
        return 'FIFTH';
      case Standard.SIXTH:
        return 'SIXTH';
      case Standard.SEVENTH:
        return 'SEVENTH';
      case Standard.EIGHTH:
        return 'EIGHTH';
      case Standard.NINTH:
        return 'NINTH';
      case Standard.TENTH:
        return 'TENTH';
      case Standard.ELEVENTH:
        return 'ELEVENTH';
      case Standard.TWELFTH:
        return 'TWELFTH';
      default:
        throw Exception('Invalid standard');
    }
  }

  // Convert string to Standard enum
  static Standard fromJson(String json) {
    switch (json) {
      case 'LKG':
        return Standard.LKG;
      case 'UKG':
        return Standard.UKG;
      case 'FIRST':
        return Standard.FIRST;
      case 'SECOND':
        return Standard.SECOND;
      case 'THIRD':
        return Standard.THIRD;
      case 'FOURTH':
        return Standard.FOURTH;
      case 'FIFTH':
        return Standard.FIFTH;
      case 'SIXTH':
        return Standard.SIXTH;
      case 'SEVENTH':
        return Standard.SEVENTH;
      case 'EIGHTH':
        return Standard.EIGHTH;
      case 'NINTH':
        return Standard.NINTH;
      case 'TENTH':
        return Standard.TENTH;
      case 'ELEVENTH':
        return Standard.ELEVENTH;
      case 'TWELFTH':
        return Standard.TWELFTH;
      default:
        throw Exception('Unknown standard: $json');
    }
  }
}
