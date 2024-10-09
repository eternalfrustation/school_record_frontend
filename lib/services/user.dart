// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';

final webClient = BrowserClient()..withCredentials = true;

const baseUrl = "https://localhost:3000";

Future<User?> getUserProfile() async {
  return webClient.get(Uri.parse("$baseUrl/user")).then(
      (e) => e.statusCode == 200 ? User.fromJson(json.decode(e.body)) : null);
}

class UserState extends ChangeNotifier {
  User? _user;
  User? get user => _user;

  Future<bool> signIn(String username, String password) async {
    var resp = await webClient.post(Uri.parse("$baseUrl/auth"),
        body: {"email": username, "password": password});
    if (resp.statusCode != 200) {
      return false;
    }
    _user = User.fromJson(json.decode(resp.body));
	notifyListeners();
    return true;
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
  final int schoolId;
  final bool photo;

  User({
    required this.id,
    required this.fname,
    required this.lname,
    required this.dob,
    required this.contact,
    required this.email,
    required this.role,
    required this.schoolId,
    required this.photo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fname: json['fname'],
      lname: json['lname'],
      dob: DateTime.parse(json['dob']),
      contact: json['contact'],
      email: json['email'],
      role: Role.fromValue(json['role']),
      schoolId: json['school_id'],
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
      'school_id': schoolId,
      'photo': photo,
    };
  }
}

class School {
  final int id;
  final String name;
  final String address;
  final Board board;
  final DateTime subscriptionStart;
  final bool photo;

  School({
    required this.id,
    required this.name,
    required this.address,
    required this.board,
    required this.subscriptionStart,
    required this.photo,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      board: Board.values.firstWhere((e) => e.toString() == 'Board.${json['board']}'),
      subscriptionStart: DateTime.parse(json['subscription_start'] as String),
      photo: json['photo'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'board': board.toString().split('.').last,
      'subscription_start': subscriptionStart.toIso8601String(),
      'photo': photo,
    };
  }
}

enum Board {
  CBSE,
  CICSE,
  NIOS,
  STATE;

  static Board fromString(String value) {
    return Board.values.firstWhere((e) => e.toString() == 'Board.$value', 
        orElse: () => throw ArgumentError('Invalid Board value: $value'));
  }

  String toJson() => toString().split('.').last;
}

extension BoardParsing on Board {
  static Board fromJson(String json) => Board.fromString(json);
}
