import '../secrets.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

class DonationUtils {
  static Future<List<int>> getDonations() async {
    List<int> data = [];
    var response = await http.get(
      'https://twist.moe/api/donation',
      headers: {
        'x-access-token': x_access_token,
      },
    );

    Map<String, dynamic> jsonData = jsonDecode(response.body);

    data.add(jsonData["received"].floor());
    data.add(jsonData["target"].floor());
    return data;
  }
}
