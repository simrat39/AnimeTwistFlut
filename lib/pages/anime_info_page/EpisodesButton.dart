import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../models/EpisodeModel.dart';

class EpisodesButton extends StatelessWidget {
  final List<EpisodeModel> episodes;

  EpisodesButton({
    @required this.episodes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.height * 0.16,
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
            minFontSize: 10.0,
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
