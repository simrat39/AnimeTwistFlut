// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:anime_twist_flut/models/EpisodeModel.dart';
import 'package:anime_twist_flut/pages/anime_info_page/episodes/EpisodeCard.dart';

class EpisodesSliver extends StatelessWidget {
  final Key key;
  final List<EpisodeModel> episodes;

  EpisodesSliver({
    this.key,
    @required this.episodes,
  }) : super(key: key);

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
            return Padding(
              padding: EdgeInsets.all(
                1.0,
              ),
              child: EpisodeCard(
                episodeModel: episodes.elementAt(index),
                episodes: episodes,
              ),
            );
          },
          childCount: episodes.length,
        ),
      ),
    );
  }
}
