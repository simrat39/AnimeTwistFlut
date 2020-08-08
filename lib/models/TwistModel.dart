// Package imports:
import 'package:hive/hive.dart';

part 'TwistModel.g.dart';

@HiveType(typeId: 0)
class TwistModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String altTitle;

  @HiveField(3)
  final int season;

  @HiveField(4)
  final bool ongoing;

  @HiveField(5)
  final int kitsuId;

  @HiveField(6)
  final String slug;

  TwistModel(
      {this.id,
      this.title,
      this.altTitle,
      this.season,
      this.ongoing,
      this.kitsuId,
      this.slug});
}
