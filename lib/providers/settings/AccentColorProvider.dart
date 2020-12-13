import 'package:anime_twist_flut/providers/settings/CustomSettingProvider.dart';
import 'package:flutter/material.dart';

class AccentColorProvider extends CustomSettingProvider<Color> {
  @override
  String exceptionMessage = "An error occured while getting accent data";

  static const Color DEFAULT_COLOR = Colors.pinkAccent;

  @override
  String prefName = "accent";

  @override
  Color data = DEFAULT_COLOR;

  @override
  void updateValue(Color newValue) {
    data = newValue;
    notifyListeners();
  }

  @override
  Future initData() async {
    pref = await getPref();
    data = Color(pref.getInt(prefName) ?? DEFAULT_COLOR.value);
    notifyListeners();
  }

  @override
  void writePref() {
    pref.setInt(prefName, data.value);
  }
}
