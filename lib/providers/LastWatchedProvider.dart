// Flutter imports:
import 'package:AnimeTwistFlut/models/LastWatchedModel.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import '../models/EpisodeModel.dart';
import '../models/KitsuModel.dart';
import '../models/TwistModel.dart';

class LastWatchedProvider extends ChangeNotifier {
  List<LastWatchedModel> lastWatchedAnimes;
  static const int MAX_LEN = 5;

  Future initData() async {
    await Hive.initFlutter((await getApplicationDocumentsDirectory()).path);
    Hive.registerAdapter<TwistModel>(TwistModelAdapter());
    Hive.registerAdapter<KitsuModel>(KitsuModelAdapter());
    Hive.registerAdapter<EpisodeModel>(EpisodeModelAdapter());
    Hive.registerAdapter<LastWatchedModel>(LastWatchedModelAdapter());
    var box = await Hive.openBox('lastWatched');
    lastWatchedAnimes = box.get('list');
  }

  // TODO: Cleanup on 12 Sep 20
  void addToLastWatched({
    TwistModel twistModel,
    KitsuModel kitsuModel,
    EpisodeModel episodeModel,
  }) {
    var box = Hive.box('lastWatched');
    LastWatchedModel lastWatchedModel = LastWatchedModel(
      twistModel,
      kitsuModel,
      episodeModel,
    );
    if (lastWatchedAnimes == null) lastWatchedAnimes = [];

    // If lastWatchedAnimes already contains the anime we are trying to add,
    // then remove that anime from the list and proceed.
    int index = isAlreadyInWatching(lastWatchedModel);
    if (index != -1) {
      lastWatchedAnimes.removeAt(index);
    }

    // If lastWatchedAnimes has more than MAX_LEN anime, then remove the oldest
    // anime and add the anime we are trying to add to index 0 by making a new
    // list and making it the first element.
    // Else add anime to lastWatchedModel
    if (lastWatchedAnimes.length >= MAX_LEN) {
      lastWatchedAnimes.removeAt(0);
      List<LastWatchedModel> lis = [lastWatchedModel];
      lis.addAll(lastWatchedAnimes.getRange(0, 4));
      lastWatchedAnimes = lis;
    } else {
      lastWatchedAnimes.add(lastWatchedModel);
    }

    // Write to the box and notifyListeners that data has been updated
    box.put('list', lastWatchedAnimes);
    notifyListeners();
  }

  /// Checks if [lastWatchedAnimes] contains [lastWatchedModel] and returns its
  /// index, else returns -1
  int isAlreadyInWatching(LastWatchedModel lastWatchedModel) {
    int index = -1;
    for (int i = 0; i < lastWatchedAnimes.length; i++) {
      index++;
      if (lastWatchedAnimes[i].twistModel == lastWatchedModel.twistModel) {
        return index;
      }
    }
    return -1;
  }

  bool hasData() {
    return lastWatchedAnimes != null && lastWatchedAnimes.isNotEmpty;
  }

  static LastWatchedProvider provider = LastWatchedProvider();
}
