import 'dart:async';

import 'package:anime_twist_flut/animations/Transitions.dart';
import 'package:anime_twist_flut/models/TwistModel.dart';
import 'package:anime_twist_flut/pages/anime_info_page/AnimeInfoPage.dart';
import 'package:anime_twist_flut/pages/favourites_page/FavouritesPage.dart';
import 'package:anime_twist_flut/pages/homepage/HomePage.dart';
import 'package:anime_twist_flut/pages/root_window/root_window_landscape.dart';
import 'package:anime_twist_flut/pages/root_window/root_window_portrait.dart';
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';
import 'package:anime_twist_flut/widgets/device_orientation_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:uni_links/uni_links.dart';
import 'package:supercharged_dart/supercharged_dart.dart';

class RootWindow extends StatefulWidget {
  RootWindow({Key key}) : super(key: key);

  @override
  _RootWindowState createState() => _RootWindowState();
}

class _RootWindowState extends State<RootWindow> with TickerProviderStateMixin {
  TabController _tabController;
  StreamSubscription _uriSub;

  var pages = [HomePage(), FavouritesPage()];
  final indexProvider = StateProvider<int>((ref) => 0);

  @override
  void dispose() {
    super.dispose();

    _uriSub.cancel();
    _tabController.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Check and launch an anime page on initial app launch, this is needed when
    // the app is not running in the background and the user clicks a relevant
    // link.
    _checkURIAndLaunchPage();
    // Check and launch a page every times a user clicks on a relevant link.
    _uriSub = getLinksStream().listen((String url) {
      _checkURIAndLaunchPage(url);
    });
    _tabController = TabController(length: pages.length, vsync: this);

    _tabController.addListener(() {
      context.read(indexProvider).state = _tabController.index;
    });

    context.read(indexProvider).addListener((state) {
      _tabController.animateTo(state);
    });
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

  @override
  Widget build(BuildContext context) {
    return DeviceOrientationBuilder(
      portrait: RootWindowPortrait(
        tabController: _tabController,
        pages: pages,
      ),
      landscape: RootWindowLandscape(
        indexProvider: indexProvider,
        pages: pages,
      ),
    );
  }
}
