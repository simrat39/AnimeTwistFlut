// Flutter imports:
import 'dart:async';

import 'package:anime_twist_flut/models/TwistModel.dart';
import 'package:anime_twist_flut/pages/anime_info_page/AnimeInfoPage.dart';
import 'package:anime_twist_flut/pages/homepage/to_watch_row/ToWatchRow.dart';
import 'package:anime_twist_flut/services/AppUpdateService.dart';
import 'package:anime_twist_flut/widgets/device_orientation_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:supercharged/supercharged.dart';

// Project imports:
import '../../animations/Transitions.dart';
import '../../services/twist_service/TwistApiService.dart';
import 'recently_watched_slider/RecentlyWatchedSlider.dart';
import 'MOTDCard.dart';
import 'ViewAllAnimeCard.dart';
import 'donation_card/DonationCard.dart';
import 'explore_slider/ExploreSlider.dart';
import 'package:uni_links/uni_links.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  StreamSubscription _uriSub;

  @override
  void initState() {
    // Check and launch an anime page on initial app launch, this is needed when
    // the app is not running in the background and the user clicks a relevant
    // link.
    _checkURIAndLaunchPage();
    // Check and launch a page every times a user clicks on a relevant link.
    _uriSub = getLinksStream().listen((String url) {
      _checkURIAndLaunchPage(url);
    });
    super.initState();
  }

  @override
  void dispose() {
    _uriSub.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppUpdateService appUpdateService = AppUpdateService();
    appUpdateService.checkUpdate(context: context);
  }

  Future _checkURIAndLaunchPage([String url]) async {
    // Wait for initData() to finish fetching and making all the anime models
    while (TwistApiService.allTwistModel.isEmpty) {
      await Future.delayed(200.milliseconds);
    }

    try {
      String recievedUrl = (url ?? await getInitialLink()) ?? "";
      RegExp regex = RegExp(r'https://twist.moe/a/(.*)/+(.*)');
      Iterable<Match> matches = regex.allMatches(recievedUrl);
      String slug = matches.length > 0 ? matches.elementAt(0).group(1) : "";
      int episodeNum =
          matches.length > 0 ? int.parse(matches.elementAt(0).group(2)) : null;

      if (slug.isNotEmpty) {
        for (int i = 0; i < TwistApiService.allTwistModel.length; i++) {
          TwistModel twistModel = TwistApiService.allTwistModel.elementAt(i);
          if (twistModel.slug == slug) {
            // If the current page is home page, then launch the anime page
            // normally, but if its any other page, then launch replaced as we
            // dont want to nest a lot of pages, if users spams the same link
            // again and again.
            if (ModalRoute.of(context).isCurrent) {
              Transitions.slideTransition(
                context: context,
                pageBuilder: () => AnimeInfoPage(
                  twistModel: twistModel,
                  isFromRecentlyWatched: episodeNum > 1 ? true : false,
                  lastWatchedEpisodeNum: episodeNum,
                ),
              );
            } else {
              Transitions.slideTransitionReplaced(
                context: context,
                pageBuilder: () => AnimeInfoPage(
                  twistModel: twistModel,
                  isFromRecentlyWatched: episodeNum > 1 ? true : false,
                  lastWatchedEpisodeNum: episodeNum,
                ),
              );
            }
          }
        }
      }
    } on PlatformException {
      // handle later
    }
  }

  final List<Widget> widgets = [
    RecentlyWatchedSlider(),
    SizedBox(
      height: 15.0,
    ),
    ToWatchRow(),
    ExploreRow(),
    Padding(
      padding: EdgeInsets.only(
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
      portrait: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => widgets.elementAt(index),
                childCount: widgets.length),
          ),
        ],
      ),
      landscape: Row(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => widgets.elementAt(index),
                    childCount: 3,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => widgets.elementAt(index + 4),
                    childCount: widgets.length - 4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
