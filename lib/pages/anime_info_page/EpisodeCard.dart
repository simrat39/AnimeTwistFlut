// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// Project imports:
import '../../animations/Transitions.dart';
import '../../models/EpisodeModel.dart';
import '../../models/KitsuModel.dart';
import '../../models/TwistModel.dart';
import '../../providers/EpisodesWatchedProvider.dart';
import '../../providers/LastWatchedProvider.dart';
import '../watch_page/WatchPage.dart';

class EpisodeCard extends StatefulWidget {
  final List<EpisodeModel> episodes;
  final EpisodeModel episodeModel;
  final EpisodesWatchedProvider episodesWatchedProvider;

  final TwistModel twistModel = Get.find();

  EpisodeCard({
    @required this.episodes,
    @required this.episodeModel,
    @required this.episodesWatchedProvider,
  });

  @override
  State<StatefulWidget> createState() {
    return _EpisodeCardState();
  }
}

class _EpisodeCardState extends State<EpisodeCard> {
  KitsuModel _kitsuModel;

  @override
  void initState() {
    try {
      _kitsuModel = Get.find();
    } catch (e) {
      _kitsuModel = null;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            child: Text(prov.isWatched(widget.episodeModel.number)
                ? "Remove from watched"
                : "Add to watched"),
            onPressed: () {
              prov.toggleWatched(widget.episodeModel.number);
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
              prov.setWatchedTill(widget.episodeModel.number);
              Navigator.of(context).pop();
            },
            elevation: 0,
            color: Theme.of(context).dialogBackgroundColor,
          ),
        ],
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.07,
          child: Card(
            child: InkWell(
              onTap: () {
                Provider.of<LastWatchedProvider>(context, listen: false)
                    .setData(
                  twistModel: widget.twistModel,
                  kitsuModel: _kitsuModel,
                  episodeModel: widget.episodeModel,
                );
                Transitions.slideTransition(
                  context: context,
                  pageBuilder: () => WatchPage(
                    episodeModel: widget.episodeModel,
                    episodes: widget.episodes,
                    episodesWatchedProvider: widget.episodesWatchedProvider,
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
                      "Episode " + widget.episodeModel.number.toString(),
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
                    prov.isWatched(widget.episodeModel.number)
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
