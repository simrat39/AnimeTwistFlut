import 'dart:convert';
import '../models/KitsuModel.dart';
import '../cached_http_get/CachedHttpGet.dart';

class KitsuUtils {
  static Future<KitsuModel> getKitsuModel(int kitsuID) async {
    String response = await CachedHttpGet.get(
      Request(
        url: 'https://kitsu.io/api/edge/anime/$kitsuID',
        header: {
          'accept': 'application/vnd.api+json',
          'content-type': 'application/vnd.api+json'
        },
      ),
    );

    Map<dynamic, dynamic> jsonData = jsonDecode(response);

    return KitsuModel(
      id: jsonData["data"]["id"],
      rating: jsonData["data"]["attributes"]["averageRating"],
      imageURL: jsonData["data"]["attributes"]["posterImage"]["large"],
      description: jsonData["data"]["attributes"]["synopsis"],
      trailerURL: jsonData["data"]["attributes"]["youtubeVideoId"],
    );
  }

  // static Future<String> getThumbnailUrl(int id) async {
  //   var response = await http.get(
  //     "https://kitsu.io/api/edge/anime/$id",
  //     headers: {
  //       'accept': 'application/vnd.api+json',
  //       'content-type': 'application/vnd.api+json'
  //     },
  //   );
  //   Map<dynamic, dynamic> jsonData = jsonDecode(response.body);

  //   return jsonData["data"]["attributes"]["posterImage"]["medium"];
  // }
}
