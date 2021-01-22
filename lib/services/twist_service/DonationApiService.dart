// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// Project imports:
import '../../secrets.dart';

class DonationApiService {
  static Future<List<int>> getDonations() async {
    var response = await http.get(
      TwistApiService.BASE_API_URL + '/donation',
      headers: {
        'x-access-token': x_access_token,
      },
    );
    return await compute(_computeData, response.body);
  }

  static Future<List<int>> _computeData(String body) async {
    List<int> data = [];
    Map<String, dynamic> jsonData = jsonDecode(body);

    if (jsonData["received"] != null) {
      data.add(jsonData["received"].floor());
      data.add(jsonData["target"].floor());
    }
    return data;
  }
}
