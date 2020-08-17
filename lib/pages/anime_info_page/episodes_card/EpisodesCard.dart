// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';

// Project imports:
import '../../../models/EpisodeModel.dart';
import 'EpisodeButton.dart';
import '../../../models/KitsuModel.dart';
import '../../../models/TwistModel.dart';
import '../../../providers/EpisodesWatchedProvider.dart';

class EpisodesCard extends StatefulWidget {
  final List<EpisodeModel> episodes;
  final TwistModel twistModel;
  final KitsuModel kitsuModel;

  EpisodesCard({
    @required this.episodes,
    @required this.twistModel,
    @required this.kitsuModel,
  });
  @override
  State<StatefulWidget> createState() {
    return _EpisodesCardState();
  }
}

class _EpisodesCardState extends State<EpisodesCard> {
  ScrollController _controller;
  EpisodesWatchedProvider _episodesWatchedProvider;

  @override
  void initState() {
    _controller = ScrollController();
    _episodesWatchedProvider =
        EpisodesWatchedProvider(slug: widget.twistModel.slug);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EpisodesWatchedProvider>.value(
      value: _episodesWatchedProvider,
      child: Card(
        child: Builder(
          builder: (context) {
            List<Widget> tiles = [];
            for (int i = 0; i < widget.episodes.length; i++) {
              tiles.add(
                EpisodeButton(
                  index: i,
                  episodes: widget.episodes,
                  twistModel: widget.twistModel,
                  kitsuModel: widget.kitsuModel,
                  episodesWatchedProvider: _episodesWatchedProvider,
                ),
              );
            }
            return CupertinoScrollbar(
              isAlwaysShown: true,
              controller: _controller,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                padding: EdgeInsets.only(
                  top: 12.0,
                  left: 16.0,
                  right: 16.0,
                  bottom: 16.0,
                ),
                child: CustomScrollView(
                  controller: _controller,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.only(
                          bottom: 12.0,
                        ),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                "${widget.episodes.length} Episode" +
                                    (widget.episodes.length > 1 ? "s" : ""),
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
                                  Icons.arrow_downward,
                                  color: Colors.white,
                                  size: 25.0,
                                ),
                              ),
                              onTap: () {
                                _controller.position.animateTo(
                                  _controller.position.maxScrollExtent,
                                  duration: widget.episodes.length >= 150
                                      ? (widget.episodes.length ~/ 150).seconds
                                      : 750.milliseconds,
                                  curve: Curves.ease,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width * 0.01 ~/ 1.2,
                        mainAxisSpacing: 7.0,
                        crossAxisSpacing: 7.0,
                        childAspectRatio: 2,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Padding(
                            padding: EdgeInsets.all(
                              1.0,
                            ),
                            child: tiles[index],
                          );
                        },
                        childCount: tiles.length,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
