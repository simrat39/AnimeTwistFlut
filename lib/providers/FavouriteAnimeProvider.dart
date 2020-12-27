import 'package:anime_twist_flut/models/TwistModel.dart';
import 'package:anime_twist_flut/services/SharedPreferencesManager.dart';
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';
import 'package:flutter/foundation.dart';

class FavouriteAnimeProvider extends ChangeNotifier {
  static const String PREF_NAME = "favourite_anime";

  final SharedPreferencesManager sharedPreferencesManager;

  List<String> favouriteAnimesSlugList = [];

  FavouriteAnimeProvider(this.sharedPreferencesManager);

  /// Initializes our provider.
  /// Reads the value of [favouriteAnimesSlugList] saved on the device using
  /// SharedPreferences with key [PREF_NAME].
  Future initialize() async {
    favouriteAnimesSlugList =
        sharedPreferencesManager.preferences.getStringList(PREF_NAME);
    notifyListeners();
  }

  /// Updates the SharedPreference [PREF_NAME] with [favouriteAnimesSlugList].
  void _writeData() {
    sharedPreferencesManager.preferences
        .setStringList(PREF_NAME, favouriteAnimesSlugList);
    notifyListeners();
  }

  /// Checks if [slug] is in [favouriteAnimesSlugList] and returns true if it is
  /// present.
  bool isFavourite(String slug) {
    return favouriteAnimesSlugList.contains(slug);
  }

  /// Adds [slug] to [favouriteAnimesSlugList] and writes the data to the
  /// device.
  void addToFavourites(String slug) {
    favouriteAnimesSlugList.add(slug);
    _writeData();
  }

  /// Removes [slug] to [favouriteAnimesSlugList] and writes the data to the
  /// device.
  void removeFromFavourites(String slug) {
    favouriteAnimesSlugList.remove(slug);
    _writeData();
  }

  /// Removes everything from [favouriteAnimesSlugList] and writes the data
  /// to the device.
  void clearFavourites() {
    favouriteAnimesSlugList.clear();
    _writeData();
  }

  /// If [slug] is in [favouriteAnimesSlugList] then remove it, else add it.
  void toggleFromFavourites(String slug) {
    if (isFavourite(slug)) {
      removeFromFavourites(slug);
    } else {
      addToFavourites(slug);
    }
  }

  /// Returns a [TwistModel] for each slug in [favouriteAnimesSlugList].
  List<TwistModel> getTwistModelsForFavourites() {
    TwistApiService twistApiService = TwistApiService();
    return favouriteAnimesSlugList
        .map((e) => twistApiService.getTwistModelFromSlug(e))
        .toList();
  }

  /// Whether we have any favourites.
  bool hasData() {
    return favouriteAnimesSlugList.isNotEmpty;
  }
}
