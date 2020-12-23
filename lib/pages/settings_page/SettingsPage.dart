import 'package:anime_twist_flut/pages/homepage/AppbarText.dart';
import 'package:anime_twist_flut/pages/settings_page/AboutAppSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/AccentPickerSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/CheckUpdateSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/ResetFavouritesSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/ResetRecentlyWatchedSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/ResetToWatchSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/SettingsCategory.dart';
import 'package:anime_twist_flut/pages/settings_page/ZoomFactorSetting.dart';
import 'package:anime_twist_flut/widgets/GoBackButton.dart';
import 'package:flutter/material.dart';
import 'package:spicy_components/spicy_components.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SpicyBottomBar(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        bgColor: Theme.of(context).cardColor,
        leftItems: [
          GoBackButton(),
          AppbarText(
            custom: "settings",
          ),
        ],
      ),
      body: Scrollbar(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(height: 4.0),
            SettingsCategory(title: "Data"),
            ResetRecentlyWatchedSetting(),
            ResetToWatchSetting(),
            ResetFavouritesSetting(),
            SettingsCategory(title: "Player"),
            ZoomFactorSetting(),
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
