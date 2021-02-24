import 'package:anime_twist_flut/models/TwistModel.dart';
import 'package:anime_twist_flut/models/kitsu/KitsuModel.dart';
import 'package:anime_twist_flut/services/kitsu_service/KitsuAnimeListApiService.dart';
import 'package:anime_twist_flut/services/kitsu_service/KitsuModelApiService.dart';
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';

class KitsuApiService {
  static Future<KitsuModel> getKitsuModel(int kitsuID, bool ongoing) async {
    return KitsuModelApiService.getKitsuModel(kitsuID, ongoing);
  }

  static Future<Map<TwistModel, KitsuModel>> getAllTimePopularAnimes() async {
    var allTimePopService = KitsuAnimeListApiService(
      url: 'https://www.kitsu.io/api/edge/anime?sort=-averageRating',
      cacheKey: 'allTimePopular',
    );
    return allTimePopService.getData();
  }

  static Future<Map<TwistModel, KitsuModel>> getAiringPopular() async {
    var airingPopularService = KitsuAnimeListApiService(
      url:
          'https://www.kitsu.io/api/edge/anime?sort=-averageRating&filter[status]=current',
      cacheKey: 'airingPopular',
    );
    return airingPopularService.getData();
  }

  static Future<Map<TwistModel, KitsuModel>> getFanFavourites() async {
    var airingPopularService = KitsuAnimeListApiService(
      url: 'https://www.kitsu.io/api/edge/anime?sort=-favoritesCount',
      cacheKey: 'fanFavourites',
    );
    return airingPopularService.getData();
  }

  static Future<Map<TwistModel, KitsuModel>> getTopMovies() async {
    var topMoviesService = KitsuAnimeListApiService(
      url:
          'https://www.kitsu.io/api/edge/anime?filter[subtype]=movie&sort=-averageRating&page[limit]=20',
      cacheKey: 'topMovies',
    );
    return topMoviesService.getData();
  }

  static TwistModel getTwistModel(String kitsuId) {
    if (TwistApiService.allKitsuIds.contains(kitsuId)) {
      return TwistApiService.allTwistModel
          .elementAt(TwistApiService.allKitsuIds.indexOf(kitsuId));
    }
    return null;
  }
}
