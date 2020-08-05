import 'package:flutter/material.dart';
import '../../../models/AnimeModel.dart';
import '../../../models/KitsuModel.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../anime_info_page/AnimeInfoPage.dart';
import '../../anime_info_page/WatchTrailerButton.dart';

class ExploreCard extends StatefulWidget {
  final AnimeModel twistModel;
  final KitsuModel kitsuModel;

  ExploreCard({this.twistModel, this.kitsuModel});

  @override
  State<StatefulWidget> createState() {
    return _ExploreCardState();
  }
}

class _ExploreCardState extends State<ExploreCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15.0,
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 400),
                pageBuilder: (context, anim, secondAnim) => AnimeInfoPage(
                  animeModel: widget.twistModel,
                  kitsuModel: widget.kitsuModel,
                  heroTag: widget.twistModel.id.toString() + "fromExploreCard",
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
          borderRadius: BorderRadius.circular(
            8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Hero(
                tag: widget.twistModel.id.toString() + "fromExploreCard",
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    widget.kitsuModel.imageURL,
                    cacheWidth: 480,
                    cacheHeight: 640,
                    fit: BoxFit.cover,
                    frameBuilder: (context, child, inn, boo) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.25,
                        color: Theme.of(context).cardColor,
                        child: child,
                      );
                    },
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.25,
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
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AutoSizeText(
                        widget.twistModel.title,
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
                      WatchTrailerButton(
                        kitsuModel: widget.kitsuModel,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
