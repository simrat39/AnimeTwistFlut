// Flutter imports:
import 'dart:async';

import 'package:anime_twist_flut/main.dart';
import 'package:anime_twist_flut/models/TwistModel.dart';
import 'package:anime_twist_flut/pages/anime_info_page/AnimeInfoPage.dart';
import 'package:anime_twist_flut/pages/homepage/AppbarText.dart';
import 'package:anime_twist_flut/pages/homepage/to_watch_row/ToWatchRow.dart';
import 'package:anime_twist_flut/pages/settings_page/SettingsPage.dart';
import 'package:anime_twist_flut/providers/ToWatchProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:supercharged/supercharged.dart';

// Project imports:
import '../../animations/Transitions.dart';
import '../../providers/RecentlyWatchedProvider.dart';
import '../../services/twist_service/TwistApiService.dart';
import '../chat_page/ChatPage.dart';
import '../search_page/SearchPage.dart';
import 'recently_watched_slider/RecentlyWatchedSlider.dart';
import 'MOTDCard.dart';
import 'ViewAllAnimeCard.dart';
import 'donation_card/DonationCard.dart';
import 'explore_slider/ExploreSlider.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter_riverpod/all.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

final recentlyWatchedProvider =
    ChangeNotifierProvider<RecentlyWatchedProvider>((ref) {
  return RecentlyWatchedProvider();
});

final toWatchProvider = ChangeNotifierProvider<ToWatchProvider>((ref) {
  return ToWatchProvider();
});

class _HomePageState extends State<HomePage> {
  Future _initData;
  StreamSubscription _uriSub;

  @override
  void initState() {
    _initData = initData(context);
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

  Future _checkURIAndLaunchPage([String url]) async {
    // Wait for initData() to finish fetching and making all the anime models
    while (TwistApiService.allTwistModel.isEmpty) {
      await Future.delayed(200.milliseconds);
    }

    try {
      String recievedUrl = (url ?? await getInitialLink()) ?? "";
      RegExp regex = RegExp(r'https://twist.moe/a/(.*)/+.*');
      Iterable<Match> matches = regex.allMatches(recievedUrl);
      String slug = matches.length > 0 ? matches.elementAt(0).group(1) : "";

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
                ),
              );
            } else {
              Transitions.slideTransitionReplaced(
                context: context,
                pageBuilder: () => AnimeInfoPage(
                  twistModel: twistModel,
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

  Future initData(BuildContext context) async {
    TwistApiService twistApiService = Get.put(TwistApiService());
    await context.read(accentProvider).initData();
    await twistApiService.setTwistModels();
    await context.read(recentlyWatchedProvider).initData();
    await context.read(toWatchProvider).initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppbarText(),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
            ),
            onPressed: () {
              Transitions.slideTransition(
                context: context,
                pageBuilder: () => SettingsPage(),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.chat_bubble,
            ),
            onPressed: () {
              Transitions.slideTransition(
                context: context,
                pageBuilder: () => ChatPage(),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: () {
              Transitions.slideTransition(
                context: context,
                pageBuilder: () => SearchPage(),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _initData,
          builder: (context, snapshot) {
            if (!(snapshot.connectionState == ConnectionState.done))
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 24.0,
                    ),
                    Text(
                      "Loading Anime!",
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  RecentlyWatchedSlider(),
                  SizedBox(
                    height: 15.0,
                  ),
                  ToWatchRow(),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 15.0,
                    ),
                    child: ExploreRow(),
                  ),
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
