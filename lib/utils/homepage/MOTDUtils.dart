// Message of the day utils

// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart' as retry;

// Project imports:
import '../../secrets.dart';

class MOTDUtils {
  static Future<List<String>> getMOTD() async {
    List<String> data = [];
    var response = await retry.retry(
      () => http.get(
        'https://twist.moe/api/motd',
        headers: {
          'x-access-token': x_access_token,
        },
      ),
    );

    Map<String, dynamic> jsonData = jsonDecode(response.body);

    data.add(jsonData["title"]);
    data.add(_parseMOTD(jsonData["message"]));
    return data;
  }

  static String _parseMOTD(String motd) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return motd.replaceAll(exp, '');
  }
}
