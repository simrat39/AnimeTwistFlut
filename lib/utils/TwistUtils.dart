import '../models/AnimeModel.dart';
import '../models/SlugModel.dart';

import '../secrets.dart';

import 'dart:convert';

import '../cached_http_get/CachedHttpGet.dart';

class TwistUtils {
  static List<AnimeModel> allTwistModel = [];

  static Future getAllTwistModel() async {
    String response = await CachedHttpGet.get(
      Request(
        url: 'https://twist.moe/api/anime',
        header: {
          'x-access-token': x_access_token,
        },
      ),
    );

    List<dynamic> jsonData = jsonDecode(response);
    jsonData.shuffle();

    jsonData.forEach(
      (element) async {
        allTwistModel.add(
          AnimeModel(
            id: element["id"],
            title: element["title"],
            altTitle: element["alt_title"],
            season: element["season"],
            ongoing: element["ongoing"] == 1,
            kitsuId: element["hb_id"],
            firstDate: element["created_at"].split(" ")[0],
            slug: SlugModel(
              slug: element["slug"]["slug"],
              id: element["slug"]["id"],
              animeId: element["slug"]["anime_id"],
            ),
          ),
        );
      },
    );
  }
}
