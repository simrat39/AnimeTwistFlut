// Package imports:
import 'package:AnimeTwistFlut/models/EpisodeModel.dart';
import 'package:AnimeTwistFlut/models/KitsuModel.dart';
import 'package:AnimeTwistFlut/models/TwistModel.dart';
import 'package:hive/hive.dart';

part 'LastWatchedModel.g.dart';

@HiveType(typeId: 3)
class LastWatchedModel extends HiveObject {
  @HiveField(0)
  final TwistModel twistModel;
  @HiveField(1)
  final KitsuModel kitsuModel;
  @HiveField(2)
  final EpisodeModel episodeModel;

  LastWatchedModel(this.twistModel, this.kitsuModel, this.episodeModel);
}
