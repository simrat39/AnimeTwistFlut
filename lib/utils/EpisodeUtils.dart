import '../models/TwistModel.dart';
import '../models/EpisodeModel.dart';

import '../secrets.dart';

import '../cached_http_get/CachedHttpGet.dart';

import 'dart:convert';

class EpisodeUtils {
  static Future<List<EpisodeModel>> getEpisodes(TwistModel twistModel) async {
    List<EpisodeModel> ret = [];
    String response = await CachedHttpGet.get(
      Request(
        url: 'https://twist.moe/api/anime/' +
            twistModel.slug.slug.toString() +
            "/sources",
        header: {
          'x-access-token': x_access_token,
        },
      ),
    );
    List<dynamic> jsonData = jsonDecode(response);

    jsonData.forEach(
      (element) {
        ret.add(
          EpisodeModel(
            source: element["source"],
            number: element["number"],
          ),
        );
      },
    );

    return ret;
  }
}
