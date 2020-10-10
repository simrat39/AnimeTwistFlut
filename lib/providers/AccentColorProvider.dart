import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccentColorProvider with ChangeNotifier {
  static const DEFAULT_ACCENT = Colors.blue;
  static const String PREF_NAME = "accent";

  Color _color = DEFAULT_ACCENT;
  SharedPreferences pref;

  get color => _color;

  Future initData() async {
    pref = await SharedPreferences.getInstance();
    _color = Color(pref.getInt(PREF_NAME) ?? DEFAULT_ACCENT.value);
    notifyListeners();
  }

  void updateAccent(Color newColor) {
    _color = newColor;
    writePref();
    notifyListeners();
  }

  void writePref() {
    pref.setInt(PREF_NAME, _color.value);
  }
}
