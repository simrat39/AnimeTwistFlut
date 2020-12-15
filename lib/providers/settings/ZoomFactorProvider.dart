import 'package:anime_twist_flut/providers/settings/CustomSettingProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ZoomFactorProvider extends CustomSettingProvider<double> {
  @override
  String prefName = "zoomFactor";

  @override
  String exceptionMessage = "An error occured while getting the zoom factor";

  @override
  double data = DEFAULT_VALUE;

  @override
  SharedPreferences pref;

  static const DEFAULT_VALUE = 1.1;
  static const MIN = 1.0;
  static const MAX = 2.0;

  @override
  Future initData() async {
    try {
      pref = await getPref();
      data = pref.getDouble(prefName) ?? DEFAULT_VALUE;
    } catch (e) {
      throw Exception(exceptionMessage);
    }
    notifyListeners();
  }

  @override
  void writePref() {
    pref.setDouble(prefName, data);
  }
}
