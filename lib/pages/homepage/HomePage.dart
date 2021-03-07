import 'package:anime_twist_flut/models/TwistModel.dart';
import 'package:anime_twist_flut/models/kitsu/KitsuAnimeListModel.dart';
import 'package:anime_twist_flut/models/kitsu/KitsuModel.dart';
import 'package:anime_twist_flut/pages/discover_page/KitsuAnimeRow.dart';
import 'package:anime_twist_flut/pages/discover_page/SubCategoryText.dart';
import 'package:anime_twist_flut/pages/homepage/HomePageLandscape.dart';
import 'package:anime_twist_flut/pages/homepage/HomePagePortrait.dart';
import 'package:anime_twist_flut/pages/homepage/to_watch_row/ToWatchRow.dart';
import 'package:anime_twist_flut/services/kitsu_service/KitsuApiService.dart';
import 'package:anime_twist_flut/widgets/device_orientation_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import 'recently_watched_slider/RecentlyWatchedSlider.dart';
import 'MOTDCard.dart';
import 'ViewAllAnimeCard.dart';
import 'donation_card/DonationCard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final List<Widget> widgets = [
    RecentlyWatchedSlider(),
    ToWatchRow(),
    SubCategoryText(
      text: 'Top Airing',
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
    ),
    KitsuAnimeRow(
      futureProvider: FutureProvider<
          Tuple2<Map<TwistModel, KitsuModel>, KitsuAnimeListModel>>(
        (ref) async => await KitsuApiService.getAiringPopular(),
      ),
    ),
    SubCategoryText(
      text: 'All Time Popular',
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
    ),
    KitsuAnimeRow(
      futureProvider: FutureProvider<
          Tuple2<Map<TwistModel, KitsuModel>, KitsuAnimeListModel>>(
        (ref) async => await KitsuApiService.getAllTimePopularAnimes(),
      ),
    ),
    Padding(
      padding: EdgeInsets.only(
        top: 12.0,
        left: 15.0,
        right: 15.0,
        bottom: 8.0,
      ),
      child: DonationCard(),
    ),
    // View all anime card
    Padding(
      padding: EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        bottom: 8.0,
      ),
      child: ViewAllAnimeCard(),
    ),
    // Message Of The Day Card
    MOTDCard(),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DeviceOrientationBuilder(
      portrait: HomePagePortrait(widgets: widgets),
      landscape: HomePageLandscape(widgets: widgets),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
