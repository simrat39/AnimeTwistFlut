import 'package:anime_twist_flut/pages/homepage/HomePageLandscape.dart';
import 'package:anime_twist_flut/pages/homepage/HomePagePortrait.dart';
import 'package:anime_twist_flut/pages/homepage/to_watch_row/ToWatchRow.dart';
import 'package:anime_twist_flut/widgets/device_orientation_builder.dart';
import 'package:flutter/material.dart';

import 'recently_watched_slider/RecentlyWatchedSlider.dart';
import 'MOTDCard.dart';
import 'ViewAllAnimeCard.dart';
import 'donation_card/DonationCard.dart';
import 'explore_slider/ExploreSlider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final List<Widget> widgets = [
    RecentlyWatchedSlider(),
    SizedBox(
      height: 15.0,
    ),
    ToWatchRow(),
    ExploreRow(key: GlobalObjectKey("explore")),
    Padding(
      padding: EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        bottom: 8.0,
      ),
      child: DonationCard(key: GlobalObjectKey("donation")),
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
    MOTDCard(key: GlobalObjectKey("motd")),
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
