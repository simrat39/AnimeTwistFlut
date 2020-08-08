// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:responsive_builder/responsive_builder.dart';

// Project imports:
import '../../models/EpisodeModel.dart';
import '../../models/KitsuModel.dart';
import 'EpisodesButton.dart';
import 'RatingWidget.dart';
import 'WatchTrailerButton.dart';

class InfoCard extends StatelessWidget {
  final KitsuModel kitsuModel;
  final List<EpisodeModel> episodes;
  final ScrollController controller;

  InfoCard({
    @required this.kitsuModel,
    @required this.episodes,
    @required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: Container(
        width: double.infinity,
        height:
            orientation == Orientation.portrait ? height * 0.35 : height * 0.5,
        child: Row(
          children: <Widget>[
            Container(
              width: width * 0.45,
              height: orientation == Orientation.portrait
                  ? height * 0.35
                  : height * 0.5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
                child: Image(
                  image: NetworkImage(
                    kitsuModel.imageURL,
                  ),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: OrientationLayoutBuilder(
                portrait: (context) => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      controller: controller,
                    ),
                  ],
                ),
                landscape: (context) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    RatingWidget(
                      kitsuModel: kitsuModel,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        WatchTrailerButton(
                          kitsuModel: kitsuModel,
                        ),
                        EpisodesButton(
                          episodes: episodes,
                          controller: controller,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
