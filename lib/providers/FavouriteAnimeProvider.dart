import 'package:anime_twist_flut/models/TwistModel.dart';
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteAnimeProvider extends ChangeNotifier {
  static const String PREF_NAME = "favourite_anime";

  List<String> favouriteAnimeSlugsList = [];
  SharedPreferences pref;

  Future init() async {
    pref = await SharedPreferences.getInstance();
    favouriteAnimeSlugsList = _getStoredData();
    notifyListeners();
  }

  List<String> _getStoredData() {
    return pref.getStringList(PREF_NAME) ?? [];
  }

  void _writeData() {
    pref.setStringList(PREF_NAME, favouriteAnimeSlugsList);
    super.notifyListeners();
  }

  bool isSlugInFavourites(String val) {
    return favouriteAnimeSlugsList.contains(val);
  }

  void addToFavs(String slug) {
    favouriteAnimeSlugsList.add(slug);
    _writeData();
  }

  void removeFromFavs(String slug) {
    favouriteAnimeSlugsList.remove(slug);
    _writeData();
  }

  void clearFavsData() {
    favouriteAnimeSlugsList.clear();
    _writeData();
  }

  void toggleFromFavs(String slug) {
    if (isSlugInFavourites(slug)) {
      removeFromFavs(slug);
    } else {
      addToFavs(slug);
    }
  }

  List<TwistModel> getTwistModelsForFavs() {
    TwistApiService twistApiService = TwistApiService();
    return favouriteAnimeSlugsList
        .map((e) => twistApiService.getTwistModelFromSlug(e))
        .toList();
  }

  bool hasData() {
    return favouriteAnimeSlugsList.isNotEmpty;
  }
}
