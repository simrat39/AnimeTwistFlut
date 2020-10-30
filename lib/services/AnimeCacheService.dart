// Flutter imports:
import 'dart:convert';

import 'package:flutter/material.dart';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supercharged/supercharged.dart';

class AnimeCacheService {
  Future<SharedPreferences> getSharedPrefInstance() async {
    return await SharedPreferences.getInstance();
  }

  Future cacheAnimeData(
      {@required String data, @required DateTime dateTime}) async {
    SharedPreferences pref = await getSharedPrefInstance();
    await pref.setStringList('anime_cache', [dateTime.toString(), data]);
  }

  Future<String> getCachedAnimeData() async {
    SharedPreferences pref = await getSharedPrefInstance();
    List<String> cachedData = pref.getStringList('anime_cache');
    if (cachedData == null || cachedData[1] == null) return null;
    return cachedData[1];
  }

  Future<DateTime> getCachedDateTime() async {
    SharedPreferences pref = await getSharedPrefInstance();
    List<String> cachedData = pref.getStringList('anime_cache');
    if (cachedData == null || cachedData[0] == null) return null;
    return DateTime.parse(cachedData[0]);
  }

  bool shouldUpdateCache(
      {@required String cachedAnimeData, @required DateTime dateTime}) {
    if (cachedAnimeData == null) return true;
    DateTime now = DateTime.now();
    bool hasAnime =
        (jsonDecode(cachedAnimeData ?? "{[]}") as List<dynamic>).length > 0;
    return (!hasAnime ||
        cachedAnimeData == null ||
        cachedAnimeData.isEmpty ||
        dateTime == null ||
        now.difference(dateTime).abs() > 7.days);
  }
}
