// Dart imports:
import 'dart:convert';
import 'dart:io';

// Project imports:
import 'package:anime_twist_flut/exceptions/TwistDownException.dart';

import '../../models/TwistModel.dart';
import '../../secrets.dart';
import '../CacheService.dart';
import 'package:supercharged/supercharged.dart';
import 'package:http/http.dart';

class AnimeApiService {
  static const String baseUrl = 'https://twist.moe/api/anime';

  Future<List<TwistModel>> getAllTwistModel() async {
    // try {
    CacheService cacheService = CacheService(
      "/anime",
      7.days,
    );

    await cacheService.initialize();

    String response = await cacheService.getDataAndCacheIfNeeded(
      getData: () async {
        var ret = await get(
          baseUrl,
          headers: {
            'x-access-token': x_access_token,
          },
        );
        if (ret.statusCode != HttpStatus.ok) {
          throw TwistDownException();
        } else
          return ret.body;
      },
      onCache: () {
        print("Data is not cached or very old");
      },
      onSkipCache: () async {
        print("Data is cached");
        await Future.delayed(Duration(milliseconds: 400));
      },
      willUpdateCache: (cachedData, cachedDateTime) {
        try {
          int len = jsonDecode(cachedData).length;
          if (len > 0) return false;
        } catch (e) {
          return true;
        }
        return true;
      },
    );

    if (response == null) {
      throw TwistDownException();
    }

    List<TwistModel> ret = [];

    List<dynamic> jsonData = jsonDecode(response);

    jsonData.forEach(
      (element) async {
        ret.add(
          TwistModel.fromJson(element),
        );
      },
    );
    return ret;
  }
}
