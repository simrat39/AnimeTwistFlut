// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';

// Project imports:
import '../../animations/Transitions.dart';
import '../../models/EpisodeModel.dart';
import '../../models/KitsuModel.dart';
import '../../models/TwistModel.dart';
import '../../providers/EpisodesWatchedProvider.dart';
import '../../providers/LastWatchedProvider.dart';
import '../watch_page/WatchPage.dart';

class EpisodeCard extends StatelessWidget {
  final List<EpisodeModel> episodes;
  final TwistModel twistModel;
  final KitsuModel kitsuModel;
  final EpisodeModel episodeModel;
  final EpisodesWatchedProvider episodesWatchedProvider;

  EpisodeCard({
    @required this.episodes,
    @required this.twistModel,
    @required this.kitsuModel,
    @required this.episodeModel,
    @required this.episodesWatchedProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<EpisodesWatchedProvider>(
      builder: (context, prov, child) => Container(
        width: MediaQuery.of(context).size.height * 0.16,
        child: Card(
          child: InkWell(
            onTap: () {
              Provider.of<LastWatchedProvider>(context, listen: false).setData(
                twistModel: twistModel,
                kitsuModel: kitsuModel,
                episodeModel: episodeModel,
              );
              Transitions.slideTransition(
                context: context,
                pageBuilder: () => WatchPage(
                  episodeModel: episodeModel,
                  episodes: episodes,
                  twistModel: twistModel,
                  kitsuModel: kitsuModel,
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
    );
  }
}
