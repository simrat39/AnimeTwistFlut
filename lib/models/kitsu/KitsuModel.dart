// Package imports:
import 'package:anime_twist_flut/models/kitsu/RatingFrequency.dart';
import 'package:hive/hive.dart';

part 'KitsuModel.g.dart';

@HiveType(typeId: 1)
class KitsuModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String rating;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String posterImage;

  @HiveField(4)
  final String trailerURL;

  @HiveField(5)
  final String coverImage;

  @HiveField(6)
  final RatingFrequencies ratingFrequencies;

  KitsuModel({
    this.id,
    this.rating,
    this.description,
    this.posterImage,
    this.trailerURL,
    this.coverImage,
    this.ratingFrequencies,
  });

  factory KitsuModel.fromJson(Map<String, dynamic> data) {
    var coverData = data["data"]["attributes"]["coverImage"];
    var posterData = data["data"]["attributes"]["posterImage"];
    return KitsuModel(
      id: data["data"]["id"],
      rating: data["data"]["attributes"]["averageRating"],
      posterImage: posterData != null ? posterData["large"] : null,
      description: data["data"]["attributes"]["synopsis"],
      trailerURL: data["data"]["attributes"]["youtubeVideoId"],
      coverImage: coverData != null ? coverData["large"] : null,
      ratingFrequencies: data["data"]['attributes']['ratingFrequencies'] != null
          ? new RatingFrequencies.fromJson(
              data["data"]['attributes']['ratingFrequencies'])
          : null,
    );
  }
}
