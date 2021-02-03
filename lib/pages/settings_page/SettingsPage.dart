import 'package:anime_twist_flut/pages/homepage/AppbarText.dart';
import 'package:anime_twist_flut/pages/settings_page/AboutAppSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/AccentPickerSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/CheckUpdateSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/ClearCacheSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/DoubleTapDurationSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/PlaybackSpeedSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/ResetFavouritesSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/ResetRecentlyWatchedSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/ResetToWatchSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/SettingsCategory.dart';
import 'package:anime_twist_flut/pages/settings_page/ZoomFactorSetting.dart';
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
      body: Scrollbar(
        thickness: 4,
        child: ListView(
          children: [
            SizedBox(height: 4.0),
            SettingsCategory(title: "Data"),
            ResetRecentlyWatchedSetting(),
            ResetToWatchSetting(),
            ResetFavouritesSetting(),
            ClearCacheSetting(),
            SettingsCategory(title: "Player"),
            PlaybackSpeedSetting(),
            ZoomFactorSetting(),
            DoubleTapDurationSetting(),
            SettingsCategory(title: "Themeing"),
            AccentPickerSetting(),
            SettingsCategory(title: "Updates"),
            CheckUpdateSetting(),
            SettingsCategory(title: "Info"),
            AboutAppSetting(),
          ],
        ),
      ),
    );
  }
}
