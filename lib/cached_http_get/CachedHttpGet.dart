import 'package:http/http.dart' as http;

// A shitty cacher for http requests, works perfect for this project
class CachedHttpGet {
  static Map<String, String> cache = {};

  static Future<String> get(Request req) async {
    if (cache.keys.contains(req.url)) return cache[req.url];

    var response = await http.get(
      req.url,
      headers: req.header,
    );

    cache[req.url] = response.body;

    return response.body;
  }
}

class Request {
  final String url;
  final Map<String, String> header;

  Request({this.url, this.header});
}
