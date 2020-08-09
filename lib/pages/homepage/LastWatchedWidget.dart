// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';

// Project imports:
import '../../providers/LastWatchedProvider.dart';
import '../anime_info_page/AnimeInfoPage.dart';
import '../anime_info_page/InfoChip.dart';

class LastWatchedWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LastWatchedWidgetState();
  }
}

class _LastWatchedWidgetState extends State<LastWatchedWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Consumer<LastWatchedProvider>(
      builder: (context, prov, child) {
        if (prov.hasData())
          return Container(
            margin: EdgeInsets.only(
              left: 15.0,
              right: 15.0,
              bottom: 15.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 10.0,
                  ),
                  child: Text(
                    "Jump back in!",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: orientation == Orientation.portrait
                      ? height * 0.25
                      : height * 0.4,
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 400),
                            pageBuilder: (context, anim, secondAnim) =>
                                AnimeInfoPage(
                              twistModel: prov.twistModel,
                              // kitsuModel: prov.kitsuModel,
                            ),
                            transitionsBuilder:
                                (context, anim, secondAnim, child) {
                              var tween = Tween(
                                begin: Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).chain(
                                CurveTween(
                                  curve: Curves.ease,
                                ),
                              );
                              return SlideTransition(
                                position: anim.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(
                        8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              prov.kitsuModel.imageURL,
                              cacheWidth: 480,
                              cacheHeight: 640,
                              fit: BoxFit.cover,
                              frameBuilder: (context, child, inn, boo) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  height: orientation == Orientation.portrait
                                      ? height * 0.25
                                      : height * 0.4,
                                  color: Theme.of(context).cardColor,
                                  child: child,
                                );
                              },
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  height: orientation == Orientation.portrait
                                      ? height * 0.25
                                      : height * 0.4,
                                  color: Theme.of(context).cardColor,
                                  child: Center(
                                    child: Transform.scale(
                                      scale: 0.6,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  AutoSizeText(
                                    prov.twistModel.title,
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    minFontSize: 15.0,
                                    maxFontSize: 30.0,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0,
                                      fontFamily: "ProductSans",
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: InfoChip(
                                      text: "Season " +
                                          prov.twistModel.season.toString(),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: InfoChip(
                                      text: "Episode " +
                                          prov.episodeModel.number.toString(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        return Container();
      },
    );
  }
}
