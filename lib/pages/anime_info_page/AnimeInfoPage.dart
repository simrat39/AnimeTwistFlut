import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../models/KitsuModel.dart';
import '../../models/AnimeModel.dart';

import '../../utils/KitsuUtils.dart';

import 'AnimeInfoPageAppBar.dart';
import 'WatchTrailerButton.dart';
import 'RatingWidget.dart';
import 'DescriptionBox.dart';
import 'EpisodesButton.dart';
import 'InfoChip.dart';

class AnimeInfoPage extends StatefulWidget {
  final AnimeModel animeModel;
  final KitsuModel kitsuModel;
  final bool isFromSearchPage;
  final FocusNode focusNode;
  final String heroTag;

  AnimeInfoPage({
    this.animeModel,
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

  @override
  void initState() {
    _getKitsuModel = getKitsuModel();
    super.initState();
  }

  Future getKitsuModel() {
    if (widget.kitsuModel != null)
      return Future.delayed(
        Duration(microseconds: 1),
      );
    return KitsuUtils.getKitsuModel(widget.animeModel.kitsuId);
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
              KitsuModel kitsuModel;
              if (widget.kitsuModel != null) {
                kitsuModel = widget.kitsuModel;
              } else {
                kitsuModel = snapshot.data;
              }
              return Scrollbar(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
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
                                        if (progress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(),
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
                                    EpisodesButton(),
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
                          bottom: 20.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: 15.0,
                                left: 15.0,
                                right: 15.0,
                              ),
                              child: AutoSizeText(
                                widget.animeModel.title,
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
                                          widget.animeModel.season.toString(),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 10.0,
                                    ),
                                    child: InfoChip(
                                      text: widget.animeModel.ongoing
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
                                bottom: 25.0,
                              ),
                              child: DescriptionBox(
                                animeModel: widget.animeModel,
                                kitsuModel: kitsuModel,
                              ),
                            ),
                          ],
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
