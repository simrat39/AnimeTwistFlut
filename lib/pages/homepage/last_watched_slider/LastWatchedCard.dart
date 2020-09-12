// Flutter imports:
import 'package:AnimeTwistFlut/models/LastWatchedModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';

// Project imports:
import '../../../animations/Transitions.dart';
import '../../anime_info_page/AnimeInfoPage.dart';

class LastWatchedCard extends StatefulWidget {
  final LastWatchedModel lastWatchedModel;

  const LastWatchedCard({@required this.lastWatchedModel});

  @override
  State<StatefulWidget> createState() {
    return _LastWatchedCardState();
  }
}

class _LastWatchedCardState extends State<LastWatchedCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      margin: EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        bottom: 15.0,
      ),
      child: Container(
        width: double.infinity,
        height:
            orientation == Orientation.portrait ? height * 0.25 : height * 0.4,
        child: Card(
          child: InkWell(
            onTap: () {
              Transitions.slideTransition(
                context: context,
                pageBuilder: () => AnimeInfoPage(
                  twistModel: widget.lastWatchedModel.twistModel,
                  kitsuModel: widget.lastWatchedModel.kitsuModel,
                ),
              );
            },
            borderRadius: BorderRadius.circular(
              8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    widget.lastWatchedModel.kitsuModel?.imageURL ??
                        "https://designshack.net/wp-content/uploads/placeholder-image.png",
                    cacheWidth: 480,
                    cacheHeight: 640,
                    fit: BoxFit.cover,
                    frameBuilder: (context, child, inn, boo) {
                      return Container(
                        width: width * 0.35,
                        height: orientation == Orientation.portrait
                            ? height * 0.25
                            : height * 0.4,
                        color: Theme.of(context).cardColor,
                        child: child,
                      );
                    },
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        width: width * 0.35,
                        height: orientation == Orientation.portrait
                            ? height * 0.25
                            : height * 0.4,
                        color: Theme.of(context).cardColor,
                        child: Center(
                          child: Transform.scale(
                            scale: 0.6,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AutoSizeText(
                          widget.lastWatchedModel.twistModel.title,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 15.0,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 26,
                            height: 1.25,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.05,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  height: orientation == Orientation.portrait
                                      ? width * 0.15
                                      : height * 0.15,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).accentColor,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "S" +
                                          widget.lastWatchedModel.twistModel
                                              .season
                                              .toString(),
                                      style: TextStyle(
                                        fontSize: 35.0,
                                        fontFamily: "ProductSans",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Expanded(
                                child: Container(
                                  height: orientation == Orientation.portrait
                                      ? width * 0.15
                                      : height * 0.15,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).accentColor,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "E" +
                                          widget.lastWatchedModel.episodeModel
                                              .number
                                              .toString(),
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 35.0,
                                        fontFamily: "ProductSans",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
    );
  }
}
