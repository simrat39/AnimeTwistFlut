import 'dart:convert';

import 'package:anime_twist_flut/cached_http_get/CachedHttpGet.dart';
import 'package:anime_twist_flut/models/TwistModel.dart';
import 'package:anime_twist_flut/models/kitsu/KitsuModel.dart';
import 'package:anime_twist_flut/services/kitsu_service/KitsuApiService.dart';
import 'package:anime_twist_flut/utils/JsonUtils.dart';
import 'package:flutter/foundation.dart';
import 'package:supercharged/supercharged.dart';

import '../CacheService.dart';

class KitsuAnimeListApiService {
  final String url;
  final String cacheKey;

  KitsuAnimeListApiService({
    @required this.url,
    @required this.cacheKey,
  });

  Future<Map<TwistModel, KitsuModel>> getData() async {
    var cacheService = CacheService(
      '/kitsu/${cacheKey}',
      2.days,
    );

    await cacheService.initialize(false);

    var response = await cacheService.getDataAndCacheIfNeeded(
      getData: () async {
        return await CachedHttpGet.get(
          Request(
            url: url,
            header: {
              'accept': 'application/vnd.api+json',
              'content-type': 'application/vnd.api+json'
            },
          ),
        );
      },
      onCache: () {},
      onSkipCache: () {},
      willUpdateCache: (cachedData, __) async {
        return !JsonUtils.isValidJson(cachedData);
      },
    );

    return await _computeData(response);
  }

  Future<Map<TwistModel, KitsuModel>> _computeData(String data) async {
    Map<dynamic, dynamic> jsonData = jsonDecode(data);
    // Check if the kitsu id is invalid.
    // A better solution would be to check for the status code but CachedHttpGet
    // doesnt support this as of now.
    if (jsonData['errors'] != null) return null;

    var dataList = jsonData['data'];

    var ret = <TwistModel, KitsuModel>{};

    for (var i = 0; i < dataList.length; i++) {
      var kModel = KitsuModel.fromJson(dataList[i], true);
      var tModel = KitsuApiService.getTwistModel(kModel.id);
      if (tModel != null) {
        ret.putIfAbsent(tModel, () => kModel);
      }
    }
    return ret;
  }
}
