// Package imports:
import 'package:AnimeTwistFlut/models/EpisodeModel.dart';
import 'package:AnimeTwistFlut/models/KitsuModel.dart';
import 'package:AnimeTwistFlut/models/TwistModel.dart';
import 'package:hive/hive.dart';

part 'RecentlyWatchedModel.g.dart';

@HiveType(typeId: 3)
class RecentlyWatchedModel extends HiveObject {
  @HiveField(0)
  final TwistModel twistModel;
  @HiveField(1)
  final KitsuModel kitsuModel;
  @HiveField(2)
  final EpisodeModel episodeModel;

  RecentlyWatchedModel(this.twistModel, this.kitsuModel, this.episodeModel);
}
