// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';

// Project imports:
import '../../models/EpisodeModel.dart';
import '../../models/KitsuModel.dart';
import '../../models/TwistModel.dart';
import '../../providers/EpisodesWatchedProvider.dart';
import '../../providers/LastWatchedProvider.dart';
import '../../utils/KitsuUtils.dart';
import '../../utils/anime_info_page/EpisodeUtils.dart';
import 'AnimeInfoPageAppBar.dart';
import 'DescriptionBox.dart';
import 'EpisodeCard.dart';
import 'InfoCard.dart';
import 'InfoChip.dart';

class AnimeInfoPage extends StatefulWidget {
  final TwistModel twistModel;
  final KitsuModel kitsuModel;
  final bool isFromSearchPage;
  final FocusNode focusNode;

  AnimeInfoPage({
    this.twistModel,
    this.kitsuModel,
    this.isFromSearchPage,
    this.focusNode,
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

  @override
  void initState() {
    _initData = initData();
    _scrollController = ScrollController();
    _episodesWatchedProvider =
        EpisodesWatchedProvider(slug: widget.twistModel.slug);
    super.initState();
  }

  KitsuModel kitsuModel;
  List<EpisodeModel> episodes;

  Future initData() async {
    episodes = await EpisodeUtils.getEpisodes(widget.twistModel);
    if (widget.kitsuModel == null)
      kitsuModel = await KitsuUtils.getKitsuModel(widget.twistModel.kitsuId);
    else {
      await Future.delayed(400.milliseconds);
      kitsuModel = widget.kitsuModel;
    }
    await precacheImage(
        NetworkImage(kitsuModel?.imageURL ??
            "https://designshack.net/wp-content/uploads/placeholder-image.png"),
        context);
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
          twistModel: widget.twistModel,
        ).build(context),
        body: FutureBuilder(
          future: _initData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CupertinoScrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: Container(
                  margin: EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                  ),
                  child: CustomScrollView(
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
                                            fontSize: 32.5,
                                            fontWeight: FontWeight.bold,
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
                                      fontSize: 32.5,
                                      fontWeight: FontWeight.bold,
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
                      SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 5.0,
                          crossAxisSpacing: 5.0,
                          childAspectRatio: 3.5,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return MultiProvider(
                              providers: [
                                ChangeNotifierProvider<
                                    EpisodesWatchedProvider>.value(
                                  value: _episodesWatchedProvider,
                                ),
                                ChangeNotifierProvider<
                                    LastWatchedProvider>.value(
                                  value: LastWatchedProvider.provider,
                                ),
                              ],
                              child: Padding(
                                padding: EdgeInsets.all(
                                  1.0,
                                ),
                                child: EpisodeCard(
                                  episodeModel: episodes.elementAt(index),
                                  episodes: episodes,
                                  twistModel: widget.twistModel,
                                  kitsuModel: kitsuModel,
                                  episodesWatchedProvider:
                                      _episodesWatchedProvider,
                                ),
                              ),
                            );
                          },
                          childCount: episodes.length,
                        ),
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
