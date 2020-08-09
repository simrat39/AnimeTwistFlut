// Flutter imports:
import 'package:flutter/material.dart';

class UserModel {
  int id;
  String username;

  UserModel({
    @required this.id,
    @required this.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'],
      username: data['username'],
    );
  }
}
