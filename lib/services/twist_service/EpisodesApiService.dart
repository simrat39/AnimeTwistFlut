// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:anime_twist_flut/exceptions/TwistDownException.dart';
import 'package:anime_twist_flut/services/CacheService.dart';
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';
import 'package:supercharged_dart/supercharged_dart.dart';

import '../../cached_http_get/CachedHttpGet.dart';
import '../../models/EpisodeModel.dart';
import '../../models/TwistModel.dart';
import '../../secrets.dart';

class EpisodeApiService {
  Future<List<EpisodeModel>> getEpisodes(TwistModel twistModel) async {
    CacheService cacheService = CacheService(
      "/anime/episodes/${twistModel.slug}",
      7.days,
    );

    await cacheService.initialize(false);

    String response = await cacheService.getDataAndCacheIfNeeded(
      getData: () async {
        return await CachedHttpGet.get(
          Request(
            url: '${TwistApiService.BASE_API_URL}/anime/' +
                twistModel.slug.toString() +
                "/sources",
            header: {
              'x-access-token': x_access_token,
            },
          ),
          TwistDownException(),
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
        return twistModel.ongoing;
      },
    );

    List<EpisodeModel> ret = [];
    List<dynamic> jsonData = jsonDecode(response);

    jsonData.forEach(
      (element) {
        ret.add(
          EpisodeModel.fromJson(element),
        );
      },
    );

    return ret;
  }
}
