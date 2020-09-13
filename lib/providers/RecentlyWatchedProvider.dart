// Flutter imports:
import 'package:AnimeTwistFlut/models/RecentlyWatchedModel.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import '../models/EpisodeModel.dart';
import '../models/KitsuModel.dart';
import '../models/TwistModel.dart';

class RecentlyWatchedProvider extends ChangeNotifier {
  List<RecentlyWatchedModel> recentlyWatchedAnimes = [];
  static const int MAX_LEN = 5;
  static const String BOX_NAME = 'lastWatched';
  static const String KEY_NAME = 'list';

  Future initData() async {
    await Hive.initFlutter((await getApplicationDocumentsDirectory()).path);
    Hive.registerAdapter<TwistModel>(TwistModelAdapter());
    Hive.registerAdapter<KitsuModel>(KitsuModelAdapter());
    Hive.registerAdapter<EpisodeModel>(EpisodeModelAdapter());
    Hive.registerAdapter<RecentlyWatchedModel>(LastWatchedModelAdapter());
    var box = await Hive.openBox(BOX_NAME);

    // For whatever reason, directly assigning lastWatchedAnimes to
    // box.get(KEY_NAME) does not work, so loop through all the elements and add
    // it to the list one by one.
    dynamic contents = box.get(KEY_NAME);
    for (int i = 0; i < contents?.length ?? 0; i++) {
      recentlyWatchedAnimes.add(contents[i]);
    }
  }

  // TODO: Cleanup on 12 Sep 20
  void addToLastWatched({
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
    if (recentlyWatchedAnimes == null) recentlyWatchedAnimes = [];

    // If lastWatchedAnimes already contains the anime we are trying to add,
    // then remove that anime from the list and proceed.
    int index = isAlreadyInWatching(lastWatchedModel);
    if (index != -1) {
      recentlyWatchedAnimes.removeAt(index);
    }

    // If lastWatchedAnimes has more than MAX_LEN anime, then remove the oldest
    // anime (at index 0) and add the anime we are trying to add by
    // making a new list and making it the last element. Else add anime to
    // lastWatchedModel
    if (recentlyWatchedAnimes.length >= MAX_LEN) {
      recentlyWatchedAnimes.removeAt(0);
      recentlyWatchedAnimes.add(lastWatchedModel);
    } else {
      recentlyWatchedAnimes.add(lastWatchedModel);
    }

    // Write to the box and notifyListeners that data has been updated
    box.put(KEY_NAME, recentlyWatchedAnimes);
    notifyListeners();
  }

  /// Checks if [recentlyWatchedAnimes] contains [lastWatchedModel] and returns its
  /// index, else returns -1
  int isAlreadyInWatching(RecentlyWatchedModel lastWatchedModel) {
    int index = -1;
    for (int i = 0; i < recentlyWatchedAnimes.length; i++) {
      index++;
      if (recentlyWatchedAnimes[i].twistModel == lastWatchedModel.twistModel) {
        return index;
      }
    }
    return -1;
  }

  bool hasData() {
    return recentlyWatchedAnimes != null && recentlyWatchedAnimes.isNotEmpty;
  }

  static RecentlyWatchedProvider provider = RecentlyWatchedProvider();
}
