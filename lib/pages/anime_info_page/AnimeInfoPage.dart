// Flutter imports:
import 'dart:ui';

import 'package:anime_twist_flut/pages/anime_info_page/DescriptionWidget.dart';
import 'package:anime_twist_flut/pages/anime_info_page/WatchTrailerButton.dart';
import 'package:anime_twist_flut/pages/homepage/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:supercharged/supercharged.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:anime_twist_flut/pages/anime_info_page/episodes/EpisodesSliver.dart';
import '../../models/EpisodeModel.dart';
import '../../models/KitsuModel.dart';
import '../../models/TwistModel.dart';
import '../../providers/EpisodesWatchedProvider.dart';
import '../../services/KitsuApiService.dart';
import '../../services/twist_service/TwistApiService.dart';
import 'package:anime_twist_flut/constants.dart';

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
  ChangeNotifierProvider<EpisodesWatchedProvider> _episodesWatchedProvider;
  bool hasScrolled = false;

  final offsetProvider = StateProvider<double>((ref) {
    return 0.0;
  });

  @override
  void initState() {
    _initData = initData();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      double offset =
          _scrollController.offset / MediaQuery.of(context).size.height * 5;
      context.read(offsetProvider).state = offset;
    });
    Get.put<TwistModel>(widget.twistModel);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<TwistModel>();
    Get.delete<KitsuModel>();
    Get.delete<ChangeNotifierProvider<EpisodesWatchedProvider>>();
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
        NetworkImage(kitsuModel?.posterImage ??
            (kitsuModel?.coverImage ?? DEFAULT_IMAGE_URL)),
        context);

    _episodesWatchedProvider = ChangeNotifierProvider<EpisodesWatchedProvider>(
      (ref) {
        return EpisodesWatchedProvider(slug: widget.twistModel.slug);
      },
    );
    Get.put<ChangeNotifierProvider<EpisodesWatchedProvider>>(
        _episodesWatchedProvider);

    await context.read(_episodesWatchedProvider).getWatchedPref();
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
              return CupertinoScrollbar(
                controller: _scrollController,
                child: CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  slivers: [
                    SliverAppBar(
                      expandedHeight: orientation == Orientation.portrait
                          ? height * 0.4
                          : width * 0.28,
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
                                  (kitsuModel?.rating?.toString() ?? "??") +
                                      " / 100",
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
                                child: Consumer(
                                  builder: (context, watch, child) {
                                    final provider = watch(offsetProvider);
                                    return Image.network(
                                      kitsuModel?.posterImage ??
                                          kitsuModel?.coverImage ??
                                          DEFAULT_IMAGE_URL,
                                      fit: BoxFit.cover,
                                      alignment:
                                          Alignment(0, -provider.state.abs()),
                                    );
                                  },
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Color(0xff070E30).withOpacity(0.7),
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
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 30.0,
                                                ),
                                              ),
                                            ),
                                            Consumer(
                                              builder: (context, watch, child) {
                                                final provider =
                                                    watch(toWatchProvider);
                                                return Container(
                                                  height: 35.0,
                                                  margin: EdgeInsets.only(
                                                    left: 5.0,
                                                  ),
                                                  child: IconButton(
                                                    icon: Icon(
                                                      provider.isAlreadyInToWatch(
                                                                  widget
                                                                      .twistModel) >=
                                                              0
                                                          ? FontAwesomeIcons
                                                              .minus
                                                          : FontAwesomeIcons
                                                              .plus,
                                                    ),
                                                    onPressed: () {
                                                      provider
                                                          .toggleFromToWatched(
                                                        episodeModel: null,
                                                        kitsuModel: kitsuModel,
                                                        twistModel:
                                                            widget.twistModel,
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
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
                            padding: EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
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
