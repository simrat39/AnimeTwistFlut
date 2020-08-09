// Dart imports:
import 'dart:convert';

// Project imports:
import '../cached_http_get/CachedHttpGet.dart';
import '../models/EpisodeModel.dart';
import '../models/TwistModel.dart';
import '../secrets.dart';

class EpisodeUtils {
  static Future<List<EpisodeModel>> getEpisodes(TwistModel twistModel) async {
    List<EpisodeModel> ret = [];
    String response = await CachedHttpGet.get(
      Request(
        url: 'https://twist.moe/api/anime/' +
            twistModel.slug.toString() +
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
          EpisodeModel.fromJson(element),
        );
      },
    );

    return ret;
  }
}
