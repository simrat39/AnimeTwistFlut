import 'SlugModel.dart';

class AnimeModel {
  final int id;
  final String title;
  final String altTitle;
  final int season;
  final bool ongoing;
  final int kitsuId;
  final String firstDate;
  final SlugModel slug;

  AnimeModel(
      {this.id,
      this.title,
      this.altTitle,
      this.season,
      this.ongoing,
      this.kitsuId,
      this.firstDate,
      this.slug});
}
