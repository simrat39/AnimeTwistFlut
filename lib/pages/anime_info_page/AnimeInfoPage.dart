// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
import 'AnimeInfoPageAppBar.dart';
import 'DescriptionBox.dart';
import 'InfoCard.dart';
import 'InfoChip.dart';

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
        NetworkImage(kitsuModel?.imageURL ??
            "https://designshack.net/wp-content/uploads/placeholder-image.png"),
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
    return WillPopScope(
      onWillPop: () async {
        if (widget.isFromSearchPage ?? false) {
          FocusScope.of(context).unfocus();
        }
        return true;
      },
      child: Scaffold(
        appBar: AnimeInfoPageAppBar(
          isFromSearchPage: widget.isFromSearchPage ?? false,
        ).build(context),
        body: FutureBuilder(
          future: _initData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                scrollToEpisode(context);
              });
              return CupertinoScrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: Container(
                  margin: EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                  ),
                  child: CustomScrollView(
                    key: topListKey,
                    physics: BouncingScrollPhysics(),
                    controller: _scrollController,
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            switch (index) {
                              case 0:
                                return InfoCard(
                                  kitsuModel: kitsuModel,
                                  episodes: episodes,
                                  controller: _scrollController,
                                );
                                break;
                              case 1:
                                return Card(
                                  margin: EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 12.0,
                                          left: 16.0,
                                          right: 16.0,
                                        ),
                                        child: AutoSizeText(
                                          widget.twistModel.title,
                                          textAlign: TextAlign.start,
                                          maxLines: 3,
                                          minFontSize: 25.0,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 5.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: 15.0,
                                              ),
                                              child: InfoChip(
                                                text: "Season " +
                                                    widget.twistModel.season
                                                        .toString(),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: 10.0,
                                              ),
                                              child: InfoChip(
                                                text: widget.twistModel.ongoing
                                                    ? "Ongoing"
                                                    : "Finished",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 10.0,
                                          left: 15.0,
                                          right: 15.0,
                                          bottom: 20.0,
                                        ),
                                        child: DescriptionBox(
                                          twistModel: widget.twistModel,
                                          kitsuModel: kitsuModel,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                break;
                            }
                            return Container();
                          },
                          childCount: 2,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Card(
                          margin: EdgeInsets.only(
                            bottom: 5.0,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 16.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: AutoSizeText(
                                    "${episodes.length} Episode" +
                                        (episodes.length > 1 ? "s" : ""),
                                    minFontSize: 10.0,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: 5.0,
                                    ),
                                    child: Icon(
                                      FontAwesomeIcons.chevronDown,
                                      color: Colors.white,
                                      size: 25.0,
                                    ),
                                  ),
                                  onTap: () {
                                    _scrollController.position.animateTo(
                                      _scrollController
                                          .position.maxScrollExtent,
                                      duration: episodes.length >= 150
                                          ? (episodes.length ~/ 150).seconds
                                          : 750.milliseconds,
                                      curve: Curves.ease,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
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
