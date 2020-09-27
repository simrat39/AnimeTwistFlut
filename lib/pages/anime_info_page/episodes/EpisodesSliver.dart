// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:AnimeTwistFlut/models/EpisodeModel.dart';
import 'package:AnimeTwistFlut/pages/anime_info_page/episodes/EpisodeCard.dart';
import 'package:AnimeTwistFlut/providers/EpisodesWatchedProvider.dart';
import 'package:AnimeTwistFlut/providers/RecentlyWatchedProvider.dart';

class EpisodesSliver extends StatelessWidget {
  final Key key;
  final List<EpisodeModel> episodes;
  final EpisodesWatchedProvider episodesWatchedProvider;

  EpisodesSliver(
      {this.key,
      @required this.episodes,
      @required this.episodesWatchedProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    bool isPortrait = orientation == Orientation.portrait;
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 14.0,
      ),
      sliver: SliverGrid(
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
                ChangeNotifierProvider<RecentlyWatchedProvider>.value(
                  value: RecentlyWatchedProvider.provider,
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
      ),
    );
  }
}
