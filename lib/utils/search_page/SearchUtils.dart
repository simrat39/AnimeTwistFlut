// Package imports:
import 'package:fuzzy/data/result.dart';
import 'package:fuzzy/fuzzy.dart';

// Project imports:
import '../../models/TwistModel.dart';

class SearchUtils {
  static bool isTextInAnimeModel({String text, TwistModel twistModel}) {
    final fuse =
        Fuzzy([twistModel.title, twistModel.altTitle ?? twistModel.title]);
    List<Result<String>> res = fuse.search(text);
    if (text.isEmpty || res.isNotEmpty && res[0].score < 0.3) {
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
