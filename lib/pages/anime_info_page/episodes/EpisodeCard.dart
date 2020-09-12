// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// Project imports:
import '../../../animations/Transitions.dart';
import '../../../models/EpisodeModel.dart';
import '../../../models/KitsuModel.dart';
import '../../../models/TwistModel.dart';
import '../../../providers/EpisodesWatchedProvider.dart';
import '../../../providers/LastWatchedProvider.dart';
import '../../watch_page/WatchPage.dart';

class EpisodeCard extends StatelessWidget {
  final List<EpisodeModel> episodes;
  final EpisodeModel episodeModel;
  final EpisodesWatchedProvider episodesWatchedProvider;

  final TwistModel twistModel = Get.find();
  final KitsuModel kitsuModel = Get.find();

  EpisodeCard({
    @required this.episodes,
    @required this.episodeModel,
    @required this.episodesWatchedProvider,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Consumer<EpisodesWatchedProvider>(
      builder: (context, prov, child) => CupertinoContextMenu(
        actions: [
          RaisedButton(
            padding: EdgeInsets.symmetric(
              vertical: 20.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12.0,
              ),
            ),
            child: Text(prov.isWatched(episodeModel.number)
                ? "Remove from watched"
                : "Add to watched"),
            onPressed: () {
              prov.toggleWatched(episodeModel.number);
              Navigator.of(context).pop();
            },
            elevation: 0,
            color: Theme.of(context).dialogBackgroundColor,
          ),
          SizedBox(
            height: 5.0,
          ),
          RaisedButton(
            padding: EdgeInsets.symmetric(
              vertical: 20.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12.0,
              ),
            ),
            child: Text("Set watched till here"),
            onPressed: () {
              prov.setWatchedTill(episodeModel.number);
              Navigator.of(context).pop();
            },
            elevation: 0,
            color: Theme.of(context).dialogBackgroundColor,
          ),
        ],
        child: Container(
          width: width * 0.5,
          height: orientation == Orientation.portrait
              ? height * 0.07
              : height * 0.175,
          child: Card(
            child: InkWell(
              onTap: () {
                Provider.of<LastWatchedProvider>(context, listen: false)
                    .setData(
                  twistModel: twistModel,
                  kitsuModel: kitsuModel,
                  episodeModel: episodeModel,
                );
                Transitions.slideTransition(
                  context: context,
                  pageBuilder: () => WatchPage(
                    episodeModel: episodeModel,
                    episodes: episodes,
                    episodesWatchedProvider: episodesWatchedProvider,
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      "Episode " + episodeModel.number.toString(),
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Theme.of(context)
                            .textTheme
                            .headline6
                            .color
                            .withOpacity(
                              0.9,
                            ),
                      ),
                    ),
                    prov.isWatched(episodeModel.number)
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).accentColor,
                          )
                        : Icon(
                            Icons.navigate_next,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
