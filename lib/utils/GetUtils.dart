import 'package:get/get.dart';

T getAllowNull<T>() {
  T ret;
  try {
    ret = Get.find<T>();
  } catch (e) {}
  return ret;
}
