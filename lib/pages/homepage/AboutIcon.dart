import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.info_outline,
      ),
      onPressed: () => showAboutDialog(
        context: context,
        applicationName: "AnimeTwistFlut",
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.github,
                ),
                iconSize: 50.0,
                onPressed: () async {
                  String url = "https://github.com/simrat39/AnimeTwistFlut";
                  if (await canLaunch(url)) {
                    launch(url);
                  }
                },
              ),
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.discord,
                ),
                iconSize: 50.0,
                onPressed: () async {
                  String url = "https://discord.gg/Ea3Mq9n";
                  if (await canLaunch(url)) {
                    launch(url);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
