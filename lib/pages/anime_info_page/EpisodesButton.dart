// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';

// Project imports:
import '../../models/EpisodeModel.dart';

class EpisodesButton extends StatelessWidget {
  final List<EpisodeModel> episodes;

  EpisodesButton({
    @required this.episodes,
  });

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      width: orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.16
          : MediaQuery.of(context).size.width * 0.18,
      child: OutlineButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            8.0,
          ),
        ),
        highlightedBorderColor: Theme.of(context).accentColor,
        borderSide: BorderSide(
          color: Theme.of(context).accentColor,
          width: 2.0,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10.0,
          ),
          child: AutoSizeText(
            episodes.length.toString() + " Episodes",
            maxLines: 1,
            minFontSize: 5.0,
            maxFontSize: 20.0,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        onPressed: () {},
      ),
    );
  }
}
