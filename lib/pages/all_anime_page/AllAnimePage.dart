// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import '../../animations/Transitions.dart';
import '../../models/TwistModel.dart';
import '../../services/twist_service/TwistApiService.dart';
import '../search_page/SearchListTile.dart';
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
                FontAwesomeIcons.chevronUp,
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
                FontAwesomeIcons.chevronDown,
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
                Transitions.slideTransition(
                  context: context,
                  pageBuilder: () => SearchPage(),
                );
              },
            ),
          ],
          elevation: 0.0,
        ),
        body: ListView.builder(
          controller: _controller,
          itemBuilder: (context, index) {
            TwistModel model = TwistApiService.allTwistModel.elementAt(index);
            return SearchListTile(
              twistModel: model,
            );
          },
          itemCount: TwistApiService.allTwistModel.length,
        ),
      ),
    );
  }
}
