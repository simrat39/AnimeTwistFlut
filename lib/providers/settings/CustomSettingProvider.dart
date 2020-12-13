import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CustomSettingProvider<T> extends ChangeNotifier {
  String prefName = "pref";
  String exceptionMessage = "Could not load setting";

  T data;
  SharedPreferences pref;

  Future initData();

  Future<SharedPreferences> getPref() async {
    try {
      return await SharedPreferences.getInstance();
    } catch (e) {
      throw Exception(exceptionMessage);
    }
  }

  void updateValue(T newValue);
  void writePref();
}
