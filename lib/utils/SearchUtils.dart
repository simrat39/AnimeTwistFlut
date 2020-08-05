import '../models/TwistModel.dart';

class SearchUtils {
  static bool isTextInAnimeModel({String text, TwistModel twistModel}) {
    if (text.isEmpty ||
        twistModel.title.toLowerCase().contains(text.toLowerCase()) ||
        (twistModel.altTitle ?? twistModel.title)
            .toLowerCase()
            .contains(text.toLowerCase())) {
      return true;
    }
    return false;
  }
}
