// Message of the day utils

// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:anime_twist_flut/cached_http_get/CachedHttpGet.dart';
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';
import 'package:flutter/foundation.dart';

// Project imports:
import '../../secrets.dart';

class MOTDApiService {
  static Future<List<String>> getMOTD() async {
    String response = await CachedHttpGet.get(
      Request(
        url: TwistApiService.BASE_API_URL + '/motd',
        header: {
          'x-access-token': x_access_token,
        },
      ),
    );
    return await compute(_computeData, response);
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
