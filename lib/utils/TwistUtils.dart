// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supercharged/supercharged.dart';

// Project imports:
import '../cached_http_get/CachedHttpGet.dart';
import '../models/TwistModel.dart';
import '../secrets.dart';

class TwistUtils {
  static List<TwistModel> allTwistModel = [];

  static Future getAllTwistModel() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    /// Index 0: DateTime.now().toString()
    /// Index 1: Response from twist.moe/api/anime
    List<String> cachedData = pref.getStringList('anime_cache');

    String response;
    DateTime dt = DateTime.now();

    if (shouldUpdateCache(cachedData, dt)) {
      print("Data is not cached or very old");
      response = await CachedHttpGet.get(
        Request(
          url: 'https://twist.moe/api/anime',
          header: {
            'x-access-token': x_access_token,
          },
        ),
      );

      await pref.setStringList('anime_cache', [dt.toString(), response]);
    } else {
      print("Data is cached");
      response = cachedData[1];
    }

    List<dynamic> jsonData = jsonDecode(response);

    jsonData.forEach(
      (element) async {
        allTwistModel.add(
          TwistModel.fromJson(element),
        );
      },
    );
  }

  static bool shouldUpdateCache(List<String> cachedData, DateTime dt) {
    return (cachedData == null ||
        cachedData.isEmpty ||
        dt.difference(DateTime.parse(cachedData[0])).abs() > 3.days);
  }
}
