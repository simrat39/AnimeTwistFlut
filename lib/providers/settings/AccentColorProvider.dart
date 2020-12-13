import 'package:anime_twist_flut/providers/settings/CustomSettingProvider.dart';
import 'package:flutter/material.dart';

class AccentColorProvider extends CustomSettingProvider<Color> {
  @override
  String exceptionMessage = "An error occured while getting accent data";

  @override
  Color defaultValue = Colors.pinkAccent;

  @override
  String prefName = "accent";

  @override
  void updateValue(Color newValue) {
    data = newValue;
    notifyListeners();
  }

  @override
  Future initData() async {
    pref = await getPref();
    data = Color(pref.getInt(prefName) ?? defaultValue.value);
    notifyListeners();
  }

  @override
  void writePref() {
    pref.setInt(prefName, data.value);
  }
}
