import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../models/KitsuModel.dart';
import '../../models/TwistModel.dart';
import '../../models/EpisodeModel.dart';

import '../../animations/FadeInSlide.dart';

import '../../utils/KitsuUtils.dart';
import '../../utils/EpisodeUtils.dart';

import 'AnimeInfoPageAppBar.dart';
import 'WatchTrailerButton.dart';
import 'RatingWidget.dart';
import 'DescriptionBox.dart';
import 'EpisodesButton.dart';
import 'InfoChip.dart';
import 'EpisodesCard.dart';

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
  ItemScrollController _controller;

  @override
  void initState() {
    _getKitsuModel = getKitsuModel();
    _controller = ItemScrollController();
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.height;
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
              return FadeIn(
                child: Scrollbar(
                  child: ScrollablePositionedList.builder(
                    physics: BouncingScrollPhysics(),
                    itemScrollController: _controller,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Card(
                              margin: EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                              child: Container(
                                width: double.infinity,
                                height: height * 0.35,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: width * 0.225,
                                      height: height * 0.35,
                                      child: Hero(
                                        tag: widget.heroTag,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8.0,
                                          ),
                                          child: Image(
                                            image: NetworkImage(
                                              kitsuModel.imageURL,
                                            ),
                                            loadingBuilder:
                                                (context, child, progress) {
                                              if (progress == null)
                                                return child;
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            },
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          RatingWidget(
                                            kitsuModel: kitsuModel,
                                          ),
                                          WatchTrailerButton(
                                            kitsuModel: kitsuModel,
                                          ),
                                          EpisodesButton(
                                            episodes: episodes,
                                            controller: _controller,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                      } else if (index == 1) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: 15.0,
                            right: 15.0,
                            bottom: 20.0,
                          ),
                          child: EpisodesCard(
                            episodes: episodes,
                            twistModel: widget.twistModel,
                          ),
                        );
                      }
                      return Container();
                    },
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
