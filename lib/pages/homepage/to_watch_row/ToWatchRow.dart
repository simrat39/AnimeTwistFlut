// Flutter imports:
import 'package:AnimeTwistFlut/models/RecentlyWatchedModel.dart';
import 'package:AnimeTwistFlut/pages/homepage/HomePage.dart';
import 'package:AnimeTwistFlut/pages/homepage/explore_slider/ExploreRowItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class ToWatchRow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ToWatchRowState();
  }
}

class _ToWatchRowState extends State<ToWatchRow> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Consumer(
      builder: (context, watch, child) {
        final provider = context.read(toWatchProvider);
        if (!provider.hasData()) return Container();
        return Container(
          margin: EdgeInsets.only(
            bottom: 15.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: 15.0,
                  left: 15.0,
                ),
                child: Text(
                  "To Watch".toUpperCase(),
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
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    // The list is reversed as the animes are stored from old
                    // to new and we want the user to see the latest added
                    // anime first
                    RecentlyWatchedModel recentlyWatchedModel =
                        provider.toWatchAnimes.reversed.elementAt(index);
                    return ExploreRowItem(
                      twistModel: recentlyWatchedModel.twistModel,
                      kitsuModel: recentlyWatchedModel.kitsuModel,
                    );
                  },
                  itemCount: provider.toWatchAnimes.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
