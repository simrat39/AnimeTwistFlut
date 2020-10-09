import 'package:AnimeTwistFlut/pages/settings_page/ResetRecentlyWatchedSetting.dart';
import 'package:AnimeTwistFlut/pages/settings_page/ResetToWatchSetting.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "settings.",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Theme.of(context).textTheme.headline6.color,
                ),
              ),
              TextSpan(
                text: "moe",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          ResetRecentlyWatchedSetting(),
          ResetToWatchSetting(),
        ],
      ),
    );
  }
}
