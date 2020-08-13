// Package imports:
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class MALUtils {
  static Future launchMalLink(int malId) async {
    String url = "https://myanimelist.net/anime/$malId";
    if (await url_launcher.canLaunch(url)) {
      url_launcher.launch(url);
    }
  }
}
