// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';

// Project imports:
import '../../models/EpisodeModel.dart';
import '../../models/KitsuModel.dart';
import '../../models/TwistModel.dart';
import '../../utils/EpisodeUtils.dart';
import '../../utils/KitsuUtils.dart';
import 'AnimeInfoPageAppBar.dart';
import 'DescriptionBox.dart';
import 'EpisodesCard.dart';
import 'InfoChip.dart';
import 'InfoCard.dart';

class AnimeInfoPage extends StatefulWidget {
  final TwistModel twistModel;
  final KitsuModel kitsuModel;
  final bool isFromSearchPage;
  final FocusNode focusNode;
  final String heroTag;

  AnimeInfoPage({
    this.twistModel,
    this.kitsuModel,
    this.isFromSearchPage,
    this.focusNode,
    this.heroTag = "Hero",
  });

  @override
  State<StatefulWidget> createState() {
    return _AnimeInfoPageState();
  }
}

class _AnimeInfoPageState extends State<AnimeInfoPage> {
  Future _getKitsuModel;
  ScrollController _scrollController;

  @override
  void initState() {
    _getKitsuModel = getKitsuModel();
    _scrollController = ScrollController();
    super.initState();
  }

  KitsuModel kitsuModel;
  List<EpisodeModel> episodes;

  Future getKitsuModel() async {
    if (widget.kitsuModel == null)
      kitsuModel = await KitsuUtils.getKitsuModel(widget.twistModel.kitsuId);
    else
      kitsuModel = widget.kitsuModel;
    episodes = await EpisodeUtils.getEpisodes(widget.twistModel);
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
                isFromSearchPage: widget.isFromSearchPage ?? false)
            .build(context),
        body: FutureBuilder(
          future: _getKitsuModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                physics: ClampingScrollPhysics(),
                controller: _scrollController,
                itemCount: 2,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InfoCard(
                            heroTag: widget.heroTag,
                            kitsuModel: kitsuModel,
                            episodes: episodes,
                            controller: _scrollController,
                          ),
                          Card(
                            margin: EdgeInsets.only(
                              top: 10.0,
                              left: 15.0,
                              right: 15.0,
                              bottom: 10.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 10.0,
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: AutoSizeText(
                                    widget.twistModel.title,
                                    textAlign: TextAlign.start,
                                    maxLines: 3,
                                    minFontSize: 30.0,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 35.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 10.0,
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
                                    top: 15.0,
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
                          ),
                        ],
                      );
                      break;
                    case 1:
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          bottom: 10.0,
                        ),
                        child: EpisodesCard(
                          episodes: episodes,
                          twistModel: widget.twistModel,
                        ),
                      );
                      break;
                  }
                  return Container();
                },
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
