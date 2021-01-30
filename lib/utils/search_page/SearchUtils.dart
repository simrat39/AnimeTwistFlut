// Package imports:
import 'package:edit_distance/edit_distance.dart';

// Project imports:
import '../../models/TwistModel.dart';

// Project imports:

class SearchUtils {
  static bool isTextInAnimeModel({String text, TwistModel twistModel}) {
    String _text = text.toLowerCase();
    String _title = twistModel.title.toLowerCase();
    String _altTitle = twistModel.altTitle?.toLowerCase() ?? _title;

    JaroWinkler l = new JaroWinkler();
    if (_text.isEmpty ||
        _title.contains(_text) ||
        _altTitle.contains(_text) ||
        l.normalizedDistance(_title, _text) < 0.3 ||
        l.normalizedDistance(_altTitle, _text) < 0.3) return true;
    return false;
  }
}

extension StringExtensions on String {
  String removeWhitespace() {
    return this.replaceAll(' ', '');
  }
}
