// Flutter imports:
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
  TwistModel twistModel;
  KitsuModel kitsuModel;
  EpisodeModel episodeModel;

  Future initData() async {
    await Hive.initFlutter((await getApplicationDocumentsDirectory()).path);
    Hive.registerAdapter<TwistModel>(TwistModelAdapter());
    Hive.registerAdapter<KitsuModel>(KitsuModelAdapter());
    Hive.registerAdapter<EpisodeModel>(EpisodeModelAdapter());
    var box = await Hive.openBox('lastWatched');
    twistModel = box.get('twistModel');
    kitsuModel = box.get('kitsuModel');
    episodeModel = box.get('episodeModel');
  }

  void setData({
    TwistModel twistModel,
    KitsuModel kitsuModel,
    EpisodeModel episodeModel,
  }) {
    var box = Hive.box('lastWatched');
    box.put('twistModel', twistModel);
    box.put('kitsuModel', kitsuModel);
    box.put('episodeModel', episodeModel);
    this.twistModel = twistModel;
    this.kitsuModel = kitsuModel;
    this.episodeModel = episodeModel;
    notifyListeners();
  }

  bool hasData() {
    return twistModel != null;
  }

  static LastWatchedProvider provider = LastWatchedProvider();
}
