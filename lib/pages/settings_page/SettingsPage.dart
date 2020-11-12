import 'package:anime_twist_flut/pages/homepage/AppbarText.dart';
import 'package:anime_twist_flut/pages/settings_page/AboutAppSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/AccentPickerSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/ResetFavouritesSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/ResetRecentlyWatchedSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/ResetToWatchSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/SettingsCategory.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppbarText(
          custom: "settings",
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4.0),
          SettingsCategory(title: "Data"),
          ResetRecentlyWatchedSetting(),
          ResetToWatchSetting(),
          ResetFavouritesSetting(),
          SettingsCategory(title: "Themeing"),
          AccentPickerSetting(),
          SettingsCategory(title: "Info"),
          AboutAppSetting(),
        ],
      ),
    );
  }
}
