// Flutter imports:
import 'package:anime_twist_flut/pages/homepage/AppbarText.dart';
import 'package:anime_twist_flut/widgets/GoBackButton.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spicy_components/spicy_components.dart';

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
        bottomNavigationBar: SpicyBottomBar(
          bgColor: Theme.of(context).cardColor,
          padding: EdgeInsets.symmetric(horizontal: 8),
          leftItems: [GoBackButton(), AppbarText()],
          rightItems: [
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
        ),
        body: Scrollbar(
          controller: _controller,
          child: ListView.builder(
            controller: _controller,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              TwistModel model = TwistApiService.allTwistModel.elementAt(index);
              return SearchListTile(
                twistModel: model,
              );
            },
            itemCount: TwistApiService.allTwistModel.length,
          ),
        ),
      ),
    );
  }
}
