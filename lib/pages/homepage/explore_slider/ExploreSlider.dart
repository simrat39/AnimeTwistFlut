// Dart imports:
import 'dart:async';
import 'dart:math';

// Flutter imports:
import 'package:AnimeTwistFlut/constants.dart';
import 'package:flutter/material.dart';

// Project imports:
import '../../../models/KitsuModel.dart';
import '../../../services/KitsuApiService.dart';
import '../../../services/twist_service/TwistApiService.dart';
import 'ExploreRowItem.dart';

class ExploreRow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExploreRowState();
  }
}

class _ExploreRowState extends State<ExploreRow> {
  List<Widget> _randomCards = [];
  Future _makeCards;

  @override
  void initState() {
    _makeCards = makeRandomCards();
    super.initState();
  }

  Future makeRandomCards() async {
    var data = TwistApiService.allTwistModel;
    Random r = Random();
    KitsuApiService kitsuApiService = KitsuApiService();

    for (int i = 0; i < 10; i++) {
      int rand = r.nextInt(data.length);
      KitsuModel kitsuModel =
          await kitsuApiService.getKitsuModel(data[rand].kitsuId);
      if (kitsuModel != null)
        _randomCards.add(
          ExploreRowItem(
            twistModel: data[rand],
            kitsuModel: kitsuModel,
          ),
        );
      precacheImage(
          NetworkImage(kitsuModel.posterImage ?? DEFAULT_IMAGE_URL), context,
          size: Size(480, 640));
    }
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
            bottom: 15.0,
            left: 15.0,
          ),
          child: Text(
            "Discover new anime".toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              fontSize: 17.0,
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
                    ? height * 0.29
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
                  ? height * 0.29
                  : height * 0.4,
              margin: EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return _randomCards[index];
                },
                itemCount: _randomCards.length,
              ),
            );
          },
        ),
      ],
    );
  }
}
