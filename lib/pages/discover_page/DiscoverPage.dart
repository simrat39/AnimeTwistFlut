import 'package:anime_twist_flut/models/TwistModel.dart';
import 'package:anime_twist_flut/models/kitsu/KitsuModel.dart';
import 'package:anime_twist_flut/pages/discover_page/KitsuAnimeRow.dart';
import 'package:anime_twist_flut/pages/discover_page/SubCategoryText.dart';
import 'package:anime_twist_flut/services/kitsu_service/KitsuApiService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class DiscoverPage extends StatefulWidget {
  DiscoverPage({Key key}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      children: [
        SubCategoryText(text: "All Time Popular"),
        KitsuAnimeRow(
          futureProvider: FutureProvider<Map<TwistModel, KitsuModel>>(
            (ref) async => await KitsuApiService.getAllTimePopularAnimes(),
          ),
        ),
        SubCategoryText(text: "Top Airing"),
        KitsuAnimeRow(
          futureProvider: FutureProvider<Map<TwistModel, KitsuModel>>(
            (ref) async => await KitsuApiService.getAiringPopular(),
          ),
        ),
        SubCategoryText(text: "Fan Favourites"),
        KitsuAnimeRow(
          futureProvider: FutureProvider<Map<TwistModel, KitsuModel>>(
            (ref) async => await KitsuApiService.getFanFavourites(),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
