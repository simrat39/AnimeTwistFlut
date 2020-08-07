// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../models/TwistModel.dart';
import '../../utils/TwistUtils.dart';
import '../anime_info_page/AnimeInfoPage.dart';
import '../search_page/SearchPage.dart';

class AllAnimePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AllAnimePageState();
  }
}

class _AllAnimePageState extends State<AllAnimePage> {
  // static double _previousScrollOffset = 0;
  final ScrollController _controller =
      new ScrollController(/*initialScrollOffset: _previousScrollOffset*/);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // _previousScrollOffset = _controller.offset;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: RichText(
            text: TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "twist.",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
                ),
                TextSpan(
                  text: "moe",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.arrow_upward,
              ),
              onPressed: () {
                _controller.animateTo(
                  0.0,
                  duration: Duration(
                    milliseconds: _controller.offset ~/ 5,
                  ),
                  curve: Curves.ease,
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_downward,
              ),
              onPressed: () {
                _controller.animateTo(
                  _controller.position.maxScrollExtent,
                  duration: Duration(
                    milliseconds: _controller.offset != 0
                        ? (_controller.position.maxScrollExtent -
                                _controller.offset) ~/
                            5
                        : _controller.position.maxScrollExtent ~/ 5,
                  ),
                  curve: Curves.ease,
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.search,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 400),
                    pageBuilder: (context, anim, secondAnim) => SearchPage(),
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
            ),
          ],
          elevation: 0.0,
        ),
        body: ListView.builder(
          controller: _controller,
          itemBuilder: (context, index) {
            TwistModel model = TwistUtils.allTwistModel.elementAt(index);
            return ListTile(
              title: Text(
                model.title.toString(),
                maxLines: 1,
              ),
              subtitle: Text(
                model.ongoing
                    ? "Season " + model.season.toString() + "  |  Ongoing"
                    : "Season " + model.season.toString() + "  |  Completed",
                maxLines: 1,
              ),
              trailing: Icon(
                Icons.navigate_next,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 400),
                    pageBuilder: (context, anim, secondAnim) => AnimeInfoPage(
                      twistModel: TwistUtils.allTwistModel.elementAt(index),
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
            );
          },
          itemCount: TwistUtils.allTwistModel.length,
        ),
      ),
    );
  }
}
