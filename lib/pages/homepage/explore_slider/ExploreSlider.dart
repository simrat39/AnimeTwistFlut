// Dart imports:
import 'dart:async';
import 'dart:math';

// Flutter imports:
import 'package:anime_twist_flut/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

// Project imports:
import '../../../models/KitsuModel.dart';
import '../../../services/KitsuApiService.dart';
import '../../../services/twist_service/TwistApiService.dart';
import 'ExploreRowItem.dart';
import '../../../animations/TwistLoadingWidget.dart';

class ExploreRow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExploreRowState();
  }
}

class _ExploreRowState extends State<ExploreRow>
    with AutomaticKeepAliveClientMixin {
  List<Widget> _randomCards = [];
  FutureProvider _randomCardsProvider;

  @override
  void initState() {
    _randomCardsProvider = FutureProvider((ref) async {
      await makeRandomCards();
    });
    super.initState();
  }

  Future makeRandomCards() async {
    var data = TwistApiService.allTwistModel;
    Random r = Random();
    KitsuApiService kitsuApiService = KitsuApiService();
    _randomCards.clear();

    for (int i = 0; i < 10; i++) {
      try {
        int rand = r.nextInt(data.length);
        KitsuModel kitsuModel = await kitsuApiService.getKitsuModel(
            data[rand].kitsuId, data[rand].ongoing);
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
      } catch (e) {}
    }
    if (_randomCards.length < 4) {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double height = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Consumer(
      builder: (context, watch, child) => watch(_randomCardsProvider).when(
        data: (data) => Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Column(
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
              Container(
                height: orientation == Orientation.portrait
                    ? height * 0.29
                    : height * 0.4,
                margin: EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return _randomCards[index];
                  },
                  itemCount: _randomCards.length,
                ),
              ),
            ],
          ),
        ),
        loading: () => Container(
          width: double.infinity,
          margin: EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            bottom: 8.0,
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
                  Transform.scale(
                      scale: 0.5, child: RotatingPinLoadingAnimation()),
                  SizedBox(height: 50.0),
                  Text("Finding you some quality anime!"),
                ],
              ),
            ),
          ),
        ),
        error: (e, s) => Padding(
          padding: EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            bottom: 8.0,
          ),
          child: Card(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Whoops! An error occured"),
                    ElevatedButton(
                      child: Text("Retry"),
                      onPressed: () => context.refresh(_randomCardsProvider),
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

  @override
  bool get wantKeepAlive => true;
}
