// Package imports:
import 'package:edit_distance/edit_distance.dart';
import 'package:fuzzy/data/result.dart';
import 'package:fuzzy/fuzzy.dart';

// Project imports:
import '../../models/TwistModel.dart';
import '../../services/twist_service/TwistApiService.dart';

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

  static List<TwistModel> getSearchResults({String text}) {
    final fuse = Fuzzy(TwistApiService.allTwistModel.map((model) {
      return model.title;
    }).toList());

    List<Result<String>> res = fuse.search(text);

    List<TwistModel> ret = [];
    for (int i = 0; i < res.length; i++) {
      if (res.elementAt(i).score < 0.5) {
        for (int j = 0; j < TwistApiService.allTwistModel.length; j++) {
          TwistModel twistModel = TwistApiService.allTwistModel[j];
          if (twistModel.title == res.elementAt(i).item) {
            ret.add(twistModel);
            break;
          }
        }
      }
    }
    return ret;
  }
}

extension StringExtensions on String {
  String removeWhitespace() {
    return this.replaceAll(' ', '');
  }
}
