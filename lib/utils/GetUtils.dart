import 'package:get_it/get_it.dart';

class Get {
  static T find<T>() {
    T ret;
    try {
      ret = GetIt.I.get<T>();
    } catch (e) {}
    return ret;
  }

  static void delete<T>() {
    GetIt.I.unregister<T>();
  }

  static T put<T>(T val) {
    GetIt.I.registerSingleton<T>(val);
    return val;
  }
}
