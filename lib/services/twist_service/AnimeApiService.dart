// Dart imports:
import 'dart:convert';

// Project imports:
import '../../cached_http_get/CachedHttpGet.dart';
import '../../models/TwistModel.dart';
import '../../secrets.dart';
import '../CacheService.dart';
import 'package:supercharged/supercharged.dart';

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
      getData: () {
        return CachedHttpGet.get(
          Request(
            url: baseUrl,
            header: {
              'x-access-token': x_access_token,
            },
          ),
        );
      },
      onCache: () {
        print("Data is not cached or very old");
      },
      onSkipCache: () async {
        print("Data is cached");
        await Future.delayed(Duration(milliseconds: 400));
      },
    );

    if (response == null) {
      throw Exception("An error occured while getting all the animes :)");
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
