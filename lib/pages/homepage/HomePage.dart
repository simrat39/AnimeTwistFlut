// Flutter imports:
import 'dart:async';

import 'package:AnimeTwistFlut/models/TwistModel.dart';
import 'package:AnimeTwistFlut/pages/anime_info_page/AnimeInfoPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';

// Project imports:
import '../../animations/Transitions.dart';
import '../../providers/RecentlyWatchedProvider.dart';
import '../../services/twist_service/TwistApiService.dart';
import '../chat_page/ChatPage.dart';
import '../search_page/SearchPage.dart';
import 'AboutIcon.dart';
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

class _HomePageState extends State<HomePage> {
  Future _initData;
  StreamSubscription _uriSub;

  @override
  void initState() {
    _initData = initData();
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
      RegExp regex = RegExp(r'https://twist.moe/a/(.*).*');
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

  Future initData() async {
    TwistApiService twistApiService = Get.put(TwistApiService());
    await twistApiService.setTwistModels();
    await RecentlyWatchedProvider.provider.initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "twist.",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Theme.of(context).textTheme.headline6.color,
                ),
              ),
              TextSpan(
                text: "moe",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
        ),
        actions: [
          AboutIcon(),
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
              child: Column(
                children: [
                  ChangeNotifierProvider<RecentlyWatchedProvider>.value(
                    value: RecentlyWatchedProvider.provider,
                    child: RecentlyWatchedSlider(),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
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
                      bottom: 15.0,
                    ),
                    child: DonationCard(),
                  ),
                  // Message Of The Day Card
                  MOTDCard(),
                  // Explore anime slider
                  // View all anime card
                  Padding(
                    padding: EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                      bottom: 15.0,
                    ),
                    child: ViewAllAnimeCard(),
                  ),
                  // Donation Card
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
