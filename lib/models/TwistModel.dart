// Project imports:
import 'SlugModel.dart';

class TwistModel {
  final int id;
  final String title;
  final String altTitle;
  final int season;
  final bool ongoing;
  final int kitsuId;
  final SlugModel slug;

  TwistModel(
      {this.id,
      this.title,
      this.altTitle,
      this.season,
      this.ongoing,
      this.kitsuId,
      this.slug});
}
