// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:supercharged/supercharged.dart';

// Project imports:
import '../../models/EpisodeModel.dart';
import '../../models/TwistModel.dart';
import '../watch_page/WatchPage.dart';

class EpisodesCard extends StatelessWidget {
  final List<EpisodeModel> episodes;
  final TwistModel twistModel;
  final ScrollController _controller = ScrollController();

  EpisodesCard({@required this.episodes, @required this.twistModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Builder(
        builder: (context) {
          List<Widget> tiles = [];
          for (int i = 0; i < episodes.length; i++) {
            tiles.add(
              Container(
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
                  highlightedBorderColor: Theme.of(context).accentColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 400),
                        pageBuilder: (context, anim, secondAnim) => WatchPage(
                          episodeModel: episodes.elementAt(i),
                          episodes: episodes,
                          twistModel: twistModel,
                        ),
                        transitionsBuilder: (context, anim, secondAnim, child) {
                          var tween = Tween(
                            begin: Offset(1.0, 0.0),
                            end: Offset.zero,
                          );
                          var curvedAnimation = CurvedAnimation(
                            parent: anim,
                            curve: Curves.ease,
                          );
                          return SlideTransition(
                            position: tween.animate(curvedAnimation),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Text(
                    episodes.elementAt(i).number.toString(),
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            );
          }
          return CupertinoScrollbar(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              padding: EdgeInsets.only(
                top: 10.0,
                left: 15.0,
                right: 15.0,
                bottom: 15.0,
              ),
              child: CustomScrollView(
                controller: _controller,
                shrinkWrap: true,
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 15.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${episodes.length} Episode" +
                                (episodes.length > 1 ? "s" : ""),
                            style: TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.arrow_downward,
                            ),
                            onPressed: () {
                              _controller.position.animateTo(
                                _controller.position.maxScrollExtent,
                                duration: episodes.length >= 150
                                    ? (episodes.length ~/ 150).seconds
                                    : 750.milliseconds,
                                curve: Curves.ease,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).size.width * 0.01 ~/ 1.25,
                      mainAxisSpacing: 15.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 2,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return tiles[index];
                      },
                      childCount: tiles.length,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
