// Dart imports:
import 'dart:convert';

// Project imports:
import '../../cached_http_get/CachedHttpGet.dart';
import '../../models/TwistModel.dart';
import '../../secrets.dart';
import '../AnimeCacheService.dart';

class AnimeApiService {
  static const String baseUrl = 'https://twist.moe/api/anime';

  Future<List<TwistModel>> getAllTwistModel() async {
    try {
      AnimeCacheService cacheService = AnimeCacheService();

      String cachedAnimeData = await cacheService.getCachedAnimeData();
      DateTime cacheDate = await cacheService.getCachedDateTime();

      String response;

      List<TwistModel> ret = [];

      if (cacheService.shouldUpdateCache(
        cachedAnimeData: cachedAnimeData,
        dateTime: cacheDate,
      )) {
        print("Data is not cached or very old");
        response = await CachedHttpGet.get(
          Request(
            url: baseUrl,
            header: {
              'x-access-token': x_access_token,
            },
          ),
        );

        await cacheService.cacheAnimeData(
          data: response,
          dateTime: DateTime.now(),
        );
      } else {
        print("Data is cached");
        response = cachedAnimeData;
      }

      List<dynamic> jsonData = jsonDecode(response);

      jsonData.forEach(
        (element) async {
          ret.add(
            TwistModel.fromJson(element),
          );
        },
      );
      print("reached here");
      return ret;
    } catch (e) {
      throw Exception("Huh");
    }
  }
}
