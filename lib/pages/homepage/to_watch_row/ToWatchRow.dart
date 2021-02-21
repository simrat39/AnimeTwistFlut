// Flutter imports:
import 'package:anime_twist_flut/main.dart';
import 'package:anime_twist_flut/models/RecentlyWatchedModel.dart';
import 'package:anime_twist_flut/pages/discover_page/SubCategoryText.dart';
import 'package:anime_twist_flut/pages/homepage/explore_slider/ExploreRowItem.dart';
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
        final provider = watch(toWatchProvider);
        if (!provider.hasData()) return Container();
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubCategoryText(
                text: "To Watch",
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
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
