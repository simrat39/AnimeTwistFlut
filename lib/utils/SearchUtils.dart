import '../models/AnimeModel.dart';

class SearchUtils {
  static bool isTextInAnimeModel({String text, AnimeModel model}) {
    if (text.isEmpty ||
        model.title.toLowerCase().contains(text.toLowerCase()) ||
        (model.altTitle ?? model.title)
            .toLowerCase()
            .contains(text.toLowerCase())) {
      return true;
    }
    return false;
  }
}
