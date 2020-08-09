// Dart imports:
import 'dart:convert';

// Project imports:
import '../cached_http_get/CachedHttpGet.dart';
import '../models/KitsuModel.dart';

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

    return KitsuModel.fromJson(jsonData);
  }
}
