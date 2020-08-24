// Package imports:
import 'package:fuzzy/data/result.dart';
import 'package:fuzzy/fuzzy.dart';

// Project imports:
import '../../models/TwistModel.dart';
import '../../utils/TwistUtils.dart';

// Project imports:

class SearchUtils {
  static bool isTextInAnimeModel({String text, TwistModel twistModel}) {
    String _text = text.toLowerCase().removeWhitespace();
    if (_text.isEmpty ||
        twistModel.title.removeWhitespace().toLowerCase().contains(_text) ||
        (twistModel.altTitle?.removeWhitespace() ??
                twistModel.title.removeWhitespace())
            .toLowerCase()
            .contains(_text)) {
      return true;
    }
    return false;
  }

  static List<TwistModel> getSearchResults({String text}) {
    final fuse = Fuzzy(TwistUtils.allTwistModel.map((model) {
      return model.title;
    }).toList());

    List<Result<String>> res = fuse.search(text);

    List<TwistModel> ret = [];
    for (int i = 0; i < res.length; i++) {
      if (res.elementAt(i).score < 0.5) {
        for (int j = 0; j < TwistUtils.allTwistModel.length; j++) {
          TwistModel twistModel = TwistUtils.allTwistModel[j];
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
