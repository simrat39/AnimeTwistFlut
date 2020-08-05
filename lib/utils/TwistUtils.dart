import '../models/TwistModel.dart';
import '../models/SlugModel.dart';

import '../secrets.dart';

import 'dart:convert';

import '../cached_http_get/CachedHttpGet.dart';

class TwistUtils {
  static List<TwistModel> allTwistModel = [];

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

    jsonData.forEach(
      (element) async {
        allTwistModel.add(
          TwistModel(
            id: element["id"],
            title: element["title"],
            altTitle: element["alt_title"],
            season: element["season"],
            ongoing: element["ongoing"] == 1,
            kitsuId: element["hb_id"],
            slug: SlugModel(
              slug: element["slug"]["slug"],
            ),
          ),
        );
      },
    );
  }
}
