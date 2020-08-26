import 'package:url_launcher/url_launcher.dart';

class DonationUtils {
  static Future donatePatreon() async {
    String url = 'https://www.patreon.com/bePatron?c=1850965';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
