import 'package:flutter/material.dart';
import '../../../animations/Transitions.dart';
import 'package:provider/provider.dart';
import '../../../providers/EpisodesWatchedProvider.dart';
import '../../../models/TwistModel.dart';
import '../../../models/EpisodeModel.dart';
import '../../../models/KitsuModel.dart';
import '../../../providers/LastWatchedProvider.dart';
import '../../watch_page/WatchPage.dart';

class EpisodeButton extends StatelessWidget {
  final List<EpisodeModel> episodes;
  final TwistModel twistModel;
  final KitsuModel kitsuModel;
  final int index;
  final EpisodesWatchedProvider episodesWatchedProvider;

  EpisodeButton({
    @required this.episodes,
    @required this.twistModel,
    @required this.kitsuModel,
    @required this.index,
    @required this.episodesWatchedProvider,
  });
  @override
  Widget build(BuildContext context) {
    return Consumer<EpisodesWatchedProvider>(
      builder: (context, prov, child) => Container(
        width: MediaQuery.of(context).size.height * 0.16,
        child: OutlineButton(
          padding: EdgeInsets.symmetric(
            horizontal: 5.0,
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(
              8.0,
            ),
          ),
          borderSide: BorderSide(
            width: 2.0,
            color: prov.isWatched(index + 1)
                ? Colors.red
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
          ),
          highlightedBorderColor: Theme.of(context).accentColor,
          onPressed: () {
            Provider.of<LastWatchedProvider>(context, listen: false).setData(
              twistModel: twistModel,
              kitsuModel: kitsuModel,
              episodeModel: episodes.elementAt(index),
            );
            Transitions.slideTransition(
              context: context,
              pageBuilder: () => WatchPage(
                episodeModel: episodes.elementAt(index),
                episodes: episodes,
                twistModel: twistModel,
                kitsuModel: kitsuModel,
                episodesWatchedProvider: episodesWatchedProvider,
              ),
            );
          },
          child: Text(
            episodes.elementAt(index).number.toString(),
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
