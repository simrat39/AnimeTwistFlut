// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:anime_twist_flut/services/CacheService.dart';
import 'package:supercharged/supercharged.dart';

import '../cached_http_get/CachedHttpGet.dart';
import '../models/KitsuModel.dart';

class KitsuApiService {
  Future<KitsuModel> getKitsuModel(int kitsuID, bool ongoing) async {
    CacheService cacheService = CacheService(
      "/anime/kitsuData/$kitsuID",
      7.days,
    );

    await cacheService.initialize(false);

    String response = await cacheService.getDataAndCacheIfNeeded(
      getData: () async {
        return await CachedHttpGet.get(
          Request(
            url: 'https://kitsu.io/api/edge/anime/$kitsuID',
            header: {
              'accept': 'application/vnd.api+json',
              'content-type': 'application/vnd.api+json'
            },
          ),
        );
      },
      onCache: () {},
      onSkipCache: () {},
      willUpdateCache: (cachedData, __) {
        try {
          jsonDecode(cachedData);
        } catch (e) {
          return true;
        }
        return ongoing;
      },
    );

    Map<dynamic, dynamic> jsonData = jsonDecode(response);
    // Check if the kitsu id is invalid.
    // A better solution would be to check for the status code but CachedHttpGet
    // doesnt support this as of now.
    if (jsonData["errors"] != null) return null;

    return KitsuModel.fromJson(jsonData);
  }
}
