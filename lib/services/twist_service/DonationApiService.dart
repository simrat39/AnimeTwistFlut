// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';
import 'package:http/http.dart' as http;

// Project imports:
import '../../secrets.dart';

class DonationApiService {
  Future<List<int>> getDonations() async {
    List<int> data = [];
    var response = await http.get(
      TwistApiService.BASE_API_URL + '/donation',
      headers: {
        'x-access-token': x_access_token,
      },
    );

    Map<String, dynamic> jsonData = jsonDecode(response.body);

    if (jsonData["received"] != null) {
      data.add(jsonData["received"].floor());
      data.add(jsonData["target"].floor());
    }
    return data;
  }
}
