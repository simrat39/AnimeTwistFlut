import 'package:AnimeTwistFlut/models/EpisodeModel.dart';
import 'package:AnimeTwistFlut/pages/anime_info_page/episodes/EpisodeCard.dart';
import 'package:AnimeTwistFlut/providers/EpisodesWatchedProvider.dart';
import 'package:AnimeTwistFlut/providers/LastWatchedProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EpisodesSliver extends StatelessWidget {
  final List<EpisodeModel> episodes;
  final EpisodesWatchedProvider episodesWatchedProvider;

  EpisodesSliver(
      {@required this.episodes, @required this.episodesWatchedProvider});

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    bool isPortrait = orientation == Orientation.portrait;
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
        childAspectRatio: isPortrait ? 3.5 : 5.5,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<EpisodesWatchedProvider>.value(
                value: episodesWatchedProvider,
              ),
              ChangeNotifierProvider<LastWatchedProvider>.value(
                value: LastWatchedProvider.provider,
              ),
            ],
            child: Padding(
              padding: EdgeInsets.all(
                1.0,
              ),
              child: EpisodeCard(
                episodeModel: episodes.elementAt(index),
                episodes: episodes,
                episodesWatchedProvider: episodesWatchedProvider,
              ),
            ),
          );
        },
        childCount: episodes.length,
      ),
    );
  }
}
