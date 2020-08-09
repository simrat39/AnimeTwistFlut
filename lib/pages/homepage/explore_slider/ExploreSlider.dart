// Dart imports:
import 'dart:async';
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../models/KitsuModel.dart';
import '../../../utils/KitsuUtils.dart';
import '../../../utils/TwistUtils.dart';
import 'ExploreCard.dart';

class ExploreSlider extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExploreSliderState();
  }
}

class _ExploreSliderState extends State<ExploreSlider> {
  List<Widget> _randomCards = [];
  Future _makeCards;
  PageController _controller;

  @override
  void initState() {
    _makeCards = makeRandomCards();
    super.initState();
  }

  Future makeRandomCards() async {
    var data = TwistUtils.allTwistModel;
    Random r = Random();

    for (int i = 0; i < 10; i++) {
      int rand = r.nextInt(data.length);
      KitsuModel kitsuModel =
          await KitsuUtils.getKitsuModel(data[rand].kitsuId);
      _randomCards.add(
        ExploreCard(
          twistModel: data[rand],
          kitsuModel: kitsuModel,
        ),
      );
      precacheImage(NetworkImage(kitsuModel.imageURL), context,
          size: Size(480, 640));
    }
    _controller = PageController(
      initialPage: 1000 * _randomCards.length,
    );

    Timer.periodic(
      Duration(seconds: 5),
      (Timer timer) {
        if (ModalRoute.of(context).isCurrent) {
          int _currentPage = _controller.page ~/ 1;
          _currentPage++;

          try {
            _controller.animateToPage(
              _currentPage,
              duration: Duration(milliseconds: 1000),
              curve: Curves.ease,
            );
          } catch (e) {
            print("Caught Exception!");
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            bottom: 10.0,
            left: 15.0,
          ),
          child: Text(
            "Explore!",
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
          ),
        ),
        FutureBuilder(
          future: _makeCards,
          builder: (context, snapshot) {
            if (!(snapshot.connectionState == ConnectionState.done))
              return Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                ),
                height: orientation == Orientation.portrait
                    ? height * 0.25
                    : height * 0.4,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      8.0,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 24.0),
                        Text("Finding you some quality anime!"),
                      ],
                    ),
                  ),
                ),
              );
            return Container(
              height: orientation == Orientation.portrait
                  ? height * 0.25
                  : height * 0.4,
              child: PageView.builder(
                controller: _controller,
                itemBuilder: (context, index) {
                  return _randomCards[index % _randomCards.length];
                },
                itemCount: null,
              ),
            );
          },
        ),
      ],
    );
  }
}
