import 'package:anime_twist_flut/providers/settings/CustomSettingProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoubleTapDurationProvider extends CustomSettingProvider<int> {
  @override
  String prefName = "doubleTapDuration";

  @override
  String exceptionMessage =
      "An error occured while getting the double tap duration";

  @override
  int data = DEFAULT_VALUE;

  @override
  SharedPreferences pref;

  static const DEFAULT_VALUE = 10;
  static const POSSIBLE_VALUES = [5, 10, 15, 20, 30, 60];

  @override
  Future initData() async {
    try {
      pref = await getPref();
      data = pref.getInt(prefName) ?? DEFAULT_VALUE;
    } catch (e) {
      throw Exception(exceptionMessage);
    }
    notifyListeners();
  }

  @override
  void writePref() {
    pref.setInt(prefName, data);
  }
}
