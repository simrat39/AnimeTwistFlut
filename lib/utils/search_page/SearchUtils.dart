// Package imports:
import 'package:fuzzy/data/result.dart';
import 'package:fuzzy/fuzzy.dart';

// Project imports:
import '../../models/TwistModel.dart';
import '../../utils/TwistUtils.dart';

// Project imports:


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
