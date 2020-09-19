// Flutter imports:
import 'dart:ui';

import 'package:AnimeTwistFlut/models/RecentlyWatchedModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';

// Project imports:
import '../../../animations/Transitions.dart';
import '../../anime_info_page/AnimeInfoPage.dart';

class RecentlyWatchedCard extends StatefulWidget {
  final RecentlyWatchedModel lastWatchedModel;

  const RecentlyWatchedCard({@required this.lastWatchedModel});

  @override
  State<StatefulWidget> createState() {
    return _RecentlyWatchedCardState();
  }
}

class _RecentlyWatchedCardState extends State<RecentlyWatchedCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.network(
              widget.lastWatchedModel.kitsuModel.coverImage,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).accentColor.withOpacity(0.6),
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.85),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            ),
          ),
          Positioned(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.0,
                  ),
                  child: AutoSizeText(
                    widget.lastWatchedModel.twistModel.title.toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    minFontSize: 17.0,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  "Season " +
                      widget.lastWatchedModel.twistModel.season.toString() +
                      " Episode " +
                      widget.lastWatchedModel.episodeModel.number.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Transitions.slideTransition(
                    context: context,
                    pageBuilder: () => AnimeInfoPage(
                      twistModel: widget.lastWatchedModel.twistModel,
                      kitsuModel: widget.lastWatchedModel.kitsuModel,
                      isFromRecentlyWatched: true,
                      lastWatchedEpisodeNum:
                          widget.lastWatchedModel.episodeModel.number,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
