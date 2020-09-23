import 'package:AnimeTwistFlut/models/RecentlyWatchedModel.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hive/hive.dart';

// Project imports:
import '../models/EpisodeModel.dart';
import '../models/KitsuModel.dart';
import '../models/TwistModel.dart';
import 'RecentlyWatchedProvider.dart';

/// This class is a copy of [RecentlyWatchedProvider]
/// It uses [RecentlyWatchedModel] since it basically stores the same data as we
/// want to be saved.
class ToWatchProvider extends ChangeNotifier {
  List<RecentlyWatchedModel> toWatchAnimes = [];
  static const String BOX_NAME = 'toWatch';
  static const String KEY_NAME = 'list';

  Future initData() async {
    var box = await Hive.openBox(BOX_NAME);

    // For whatever reason, directly assigning toWatchAnimes to
    // box.get(KEY_NAME) does not work, so loop through all the elements and
    // add it to the list one by one.
    dynamic contents = box.get(KEY_NAME);
    for (int i = 0; i < contents?.length ?? 0; i++) {
      toWatchAnimes.add(contents[i]);
    }
  }

  void toggleFromToWatched({
    TwistModel twistModel,
    KitsuModel kitsuModel,
    EpisodeModel episodeModel,
  }) {
    var box = Hive.box(BOX_NAME);
    RecentlyWatchedModel lastWatchedModel = RecentlyWatchedModel(
      twistModel,
      kitsuModel,
      episodeModel,
    );
    if (toWatchAnimes == null) toWatchAnimes = [];

    // Checks if lastWatchedModel is already in toWatchAnimes, deletes if its
    // present and adds if its not
    int index = isAlreadyInToWatch(lastWatchedModel.twistModel);
    if (index != -1) {
      toWatchAnimes.removeAt(index);
    } else {
      toWatchAnimes.add(lastWatchedModel);
    }

    // Write to the box and notifyListeners that data has been updated
    box.put(KEY_NAME, toWatchAnimes);
    notifyListeners();
  }

  /// Checks if [toWatchAnimes] contains [twistModel] and returns its
  /// index, else returns -1
  int isAlreadyInToWatch(TwistModel twistModel) {
    int index = -1;
    for (int i = 0; i < toWatchAnimes.length; i++) {
      index++;
      if (toWatchAnimes[i].twistModel == twistModel) {
        return index;
      }
    }
    return -1;
  }

  bool hasData() {
    return toWatchAnimes != null && toWatchAnimes.isNotEmpty;
  }

  static ToWatchProvider provider = ToWatchProvider();
}
