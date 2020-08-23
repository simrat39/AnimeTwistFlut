// Project imports:
import '../../models/TwistModel.dart';

class SearchUtils {
  static bool isTextInAnimeModel({String text, TwistModel twistModel}) {
    if (text.isEmpty ||
        twistModel.title
            .removeWhitespace()
            .toLowerCase()
            .contains(text.toLowerCase()) ||
        (twistModel.altTitle?.removeWhitespace() ?? twistModel.title)
            .toLowerCase()
            .contains(text.toLowerCase())) {
      return true;
    }
    return false;
  }
}

extension StringExtensions on String {
  String removeWhitespace() {
    return this.replaceAll(' ', '');
  }
}
