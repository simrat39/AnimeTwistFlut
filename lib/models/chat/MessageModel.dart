// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'UserModel.dart';

class MessageModel {
  String message;
  UserModel userModel;
  DateTime time;

  MessageModel({
    @required this.message,
    @required this.userModel,
    @required this.time,
  });

  factory MessageModel.fromJson(Map<String, dynamic> data) {
    return MessageModel(
      message: data["content"]["msg"],
      userModel: UserModel.fromJson(data["content"]["user"]),
      time: DateTime.parse(data["timestamp"]).toLocal(),
    );
  }
}
