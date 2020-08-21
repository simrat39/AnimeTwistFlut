// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';

// Project imports:
import '../../../animations/Transitions.dart';
import '../../../models/KitsuModel.dart';
import '../../../models/TwistModel.dart';
import '../../anime_info_page/AnimeInfoPage.dart';
import '../../anime_info_page/WatchTrailerButton.dart';

class ExploreCard extends StatefulWidget {
  final TwistModel twistModel;
  final KitsuModel kitsuModel;

  ExploreCard({this.twistModel, this.kitsuModel});

  @override
  State<StatefulWidget> createState() {
    return _ExploreCardState();
  }
}

class _ExploreCardState extends State<ExploreCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15.0,
        ),
        child: InkWell(
          onTap: () {
            Transitions.slideTransition(
              context: context,
              pageBuilder: () => AnimeInfoPage(
                twistModel: widget.twistModel,
                kitsuModel: widget.kitsuModel,
              ),
            );
          },
          borderRadius: BorderRadius.circular(
            8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Hero(
                tag: widget.twistModel.id.toString() + "fromExploreCard",
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    widget.kitsuModel.imageURL,
                    cacheWidth: 480,
                    cacheHeight: 640,
                    fit: BoxFit.cover,
                    frameBuilder: (context, child, inn, boo) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.35,
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
                        width: MediaQuery.of(context).size.width * 0.35,
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
                        widget.twistModel.title,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 15.0,
                        maxFontSize: 30.0,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          fontFamily: "ProductSans",
                        ),
                      ),
                      WatchTrailerButton(
                        kitsuModel: widget.kitsuModel,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
