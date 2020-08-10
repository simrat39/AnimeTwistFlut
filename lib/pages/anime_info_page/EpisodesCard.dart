// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';

// Project imports:
import '../../models/EpisodeModel.dart';
import '../../models/KitsuModel.dart';
import '../../models/TwistModel.dart';
import '../../providers/LastWatchedProvider.dart';
import '../watch_page/WatchPage.dart';

class EpisodesCard extends StatelessWidget {
  final List<EpisodeModel> episodes;
  final TwistModel twistModel;
  final KitsuModel kitsuModel;
  final ScrollController _controller = ScrollController();

  EpisodesCard({
    @required this.episodes,
    @required this.twistModel,
    @required this.kitsuModel,
  });

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
                    Provider.of<LastWatchedProvider>(context, listen: false)
                        .setData(
                      twistModel: twistModel,
                      kitsuModel: kitsuModel,
                      episodeModel: episodes.elementAt(i),
                    );
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 400),
                        pageBuilder: (context, anim, secondAnim) => WatchPage(
                          episodeModel: episodes.elementAt(i),
                          episodes: episodes,
                          twistModel: twistModel,
                          kitsuModel: kitsuModel,
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
            isAlwaysShown: true,
            controller: _controller,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              padding: EdgeInsets.only(
                top: 12.0,
                left: 16.0,
                right: 16.0,
                bottom: 16.0,
              ),
              child: CustomScrollView(
                controller: _controller,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: 15.0,
                      ),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              "${episodes.length} Episode" +
                                  (episodes.length > 1 ? "s" : ""),
                              minFontSize: 10.0,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 32.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 5.0,
                              ),
                              child: Icon(
                                Icons.arrow_downward,
                                color: Colors.white,
                                size: 25.0,
                              ),
                            ),
                            onTap: () {
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
                          MediaQuery.of(context).size.width * 0.01 ~/ 1.2,
                      mainAxisSpacing: 7.0,
                      crossAxisSpacing: 7.0,
                      childAspectRatio: 2,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(
                            1.0,
                          ),
                          child: tiles[index],
                        );
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
