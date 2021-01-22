// Message of the day utils

// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// Project imports:
import '../../secrets.dart';

class MOTDApiService {
  static Future<List<String>> getMOTD() async {
    var response = await http.get(
      TwistApiService.BASE_API_URL + '/motd',
      headers: {
        'x-access-token': x_access_token,
      },
    );
    return await compute(_computeData, response.body);
  }

  static String _parseMOTD(String motd) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return motd.replaceAll(exp, '');
  }

  static Future<List<String>> _computeData(String data) async {
    List<String> ret = [];
    Map<String, dynamic> jsonData = jsonDecode(data);

    ret.add(jsonData["title"]);
    ret.add(_parseMOTD(jsonData["message"]));
    return ret;
  }
}
