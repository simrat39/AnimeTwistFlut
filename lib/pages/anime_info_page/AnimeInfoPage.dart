// Flutter imports:
import 'dart:ui';

import 'package:AnimeTwistFlut/pages/anime_info_page/DescriptionWidget.dart';
import 'package:AnimeTwistFlut/pages/anime_info_page/WatchTrailerButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:supercharged/supercharged.dart';

// Project imports:
import 'package:AnimeTwistFlut/pages/anime_info_page/episodes/EpisodesSliver.dart';
import '../../models/EpisodeModel.dart';
import '../../models/KitsuModel.dart';
import '../../models/TwistModel.dart';
import '../../providers/EpisodesWatchedProvider.dart';
import '../../services/KitsuApiService.dart';
import '../../services/twist_service/TwistApiService.dart';

class AnimeInfoPage extends StatefulWidget {
  final TwistModel twistModel;
  final KitsuModel kitsuModel;
  final bool isFromSearchPage;
  final FocusNode focusNode;
  final bool isFromRecentlyWatched;
  final int lastWatchedEpisodeNum;

  AnimeInfoPage({
    this.twistModel,
    this.kitsuModel,
    this.isFromSearchPage,
    this.focusNode,
    this.isFromRecentlyWatched = false,
    this.lastWatchedEpisodeNum = 0,
  });

  @override
  State<StatefulWidget> createState() {
    return _AnimeInfoPageState();
  }
}

class _AnimeInfoPageState extends State<AnimeInfoPage> {
  Future _initData;
  ScrollController _scrollController;
  EpisodesWatchedProvider _episodesWatchedProvider;
  GlobalKey topListKey;
  bool hasScrolled = false;

  @override
  void initState() {
    _initData = initData();
    _scrollController = ScrollController();
    _episodesWatchedProvider =
        EpisodesWatchedProvider(slug: widget.twistModel.slug);
    Get.put<TwistModel>(widget.twistModel);
    topListKey = GlobalKey();
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<TwistModel>();
    Get.delete<KitsuModel>();
    super.dispose();
  }

  KitsuModel kitsuModel;
  List<EpisodeModel> episodes;

  Future initData() async {
    KitsuApiService kitsuApiService = KitsuApiService();
    TwistApiService twistApiService = Get.find();

    episodes = await twistApiService.getEpisodesForSource(
      twistModel: widget.twistModel,
    );

    if (widget.kitsuModel == null)
      kitsuModel =
          await kitsuApiService.getKitsuModel(widget.twistModel.kitsuId);
    else {
      await Future.delayed(400.milliseconds);
      kitsuModel = widget.kitsuModel;
    }
    Get.put<KitsuModel>(kitsuModel);
    await precacheImage(
        NetworkImage(kitsuModel?.coverImage ??
            (kitsuModel?.posterImage ??
                "https://designshack.net/wp-content/uploads/placeholder-image.png")),
        context);
  }

  void scrollToEpisode(BuildContext context) {
    // Check if widget is from recently scrolled as we only want to scroll to
    // the episode if we come from a recently watched card.
    // Also check if we have already scrolled as this function may be called
    // multiple times and we dont want the user to be stuck in an animation
    // loop.
    if (widget.isFromRecentlyWatched && !hasScrolled) {
      Orientation orientation = MediaQuery.of(context).orientation;

      // Find the height of all of the items aboce the gridview and divide it by
      // 2 in portrait and 0.75 in landscape because for whatever dividing by
      // that gives better results. We get the height by adding a GlobalKey to
      // the SliverList containing everything but the episodes.
      double scrollDivideFactor =
          orientation == Orientation.portrait ? 2 : 0.75;
      double lengthToScroll =
          (topListKey.currentContext.findRenderObject() as RenderBox)
                  .size
                  .height /
              scrollDivideFactor;

      double screenHeight = MediaQuery.of(context).size.height;
      // One episode card has height of screenHeight * 0.07 in portrait /
      // screenHeight * 0.2 (a little higher than actual since its a ratio) in
      // landscape and since episodes are laid out in a grid, each row has 2
      // episode cards.
      double episodeCardHeight = orientation == Orientation.portrait
          ? screenHeight * 0.07
          : screenHeight * 0.2;
      int episodeCountInRow = 2;

      // Calculate the height of all the episodes till lastWatchedEpisodeNum and
      // add it to lengthToScroll.
      lengthToScroll +=
          episodeCardHeight * widget.lastWatchedEpisodeNum / episodeCountInRow;

      // If the lengthToScroll is greater than the actual maxScrollExtent, then
      // prevent overscrolls and weird glitches and set the lengthToScroll to
      // the maxScrollExtent.
      if (lengthToScroll > _scrollController.position.maxScrollExtent)
        lengthToScroll = _scrollController.position.maxScrollExtent;

      // Animate to the desired episode.
      // TODO: Dynamically find an appropriate duration on 13 Sep 20
      _scrollController.animateTo(
        lengthToScroll,
        duration: 1.seconds,
        curve: Curves.ease,
      );
      // Set hasScrolled to true to make sure that we dont auto scroll again in
      // the same page.
      hasScrolled = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        if (widget.isFromSearchPage ?? false) {
          FocusScope.of(context).unfocus();
        }
        return true;
      },
      child: Scaffold(
        body: FutureBuilder(
          future: _initData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                scrollToEpisode(context);
              });
              return CupertinoScrollbar(
                controller: _scrollController,
                child: CustomScrollView(
                  key: topListKey,
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  slivers: [
                    SliverAppBar(
                      expandedHeight: orientation == Orientation.portrait
                          ? height * 0.3
                          : width * 0.25,
                      actions: [
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(
                              right: 20.0,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.0,
                              vertical: 6.0,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xfff8f8f2),
                              borderRadius: BorderRadius.circular(
                                20.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.pink,
                                  ),
                                ),
                                Text(
                                  kitsuModel.rating.toString() + " / 100",
                                  style: TextStyle(
                                    color: Colors.pink,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Positioned.fill(
                                child: Image.network(
                                  kitsuModel.coverImage ??
                                      kitsuModel.posterImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned.fill(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 2.0,
                                    sigmaY: 2.0,
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context)
                                              .accentColor
                                              .withOpacity(0.6),
                                          Theme.of(context)
                                              .bottomAppBarColor
                                              .withOpacity(0.75),
                                        ],
                                        begin: Alignment.centerRight,
                                        end: Alignment.centerLeft,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                bottom: 20,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: AutoSizeText(
                                                widget.twistModel.title
                                                    .toUpperCase(),
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                minFontSize: 20.0,
                                                style: TextStyle(
                                                  letterSpacing: 1.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 30.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        (episodes?.length?.toString() ?? '0') +
                                            " Episodes | " +
                                            (widget.twistModel.ongoing
                                                ? "Ongoing"
                                                : "Finished"),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          WatchTrailerButton(
                            kitsuModel: kitsuModel,
                          ),
                          DescriptionWidget(
                            twistModel: widget.twistModel,
                            kitsuModel: kitsuModel,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              top: 16.0,
                              bottom: 8.0,
                            ),
                            child: Text(
                              "SEASON " + widget.twistModel.season.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    EpisodesSliver(
                      episodes: episodes,
                      episodesWatchedProvider: _episodesWatchedProvider,
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 15.0,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
