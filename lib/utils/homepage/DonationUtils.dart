// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart' as retry;
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import '../../secrets.dart';

class DonationUtils {
  static Future<List<int>> getDonations() async {
    List<int> data = [];
    var response = await retry.retry(
      () => http.get(
        'https://twist.moe/api/donation',
        headers: {
          'x-access-token': x_access_token,
        },
      ),
    );

    Map<String, dynamic> jsonData = jsonDecode(response.body);

    data.add(jsonData["received"].floor());
    data.add(jsonData["target"].floor());
    return data;
  }

  static Future donatePatreon() async {
    String url = 'https://www.patreon.com/bePatron?c=1850965';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
