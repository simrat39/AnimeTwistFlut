// Flutter imports:
import 'package:AnimeTwistFlut/models/LastWatchedModel.dart';
import 'package:AnimeTwistFlut/providers/LastWatchedProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

// Project imports:
import 'LastWatchedCard.dart';

class LastWatchedSliderSlider extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LastWatchedSliderSliderState();
  }
}

class _LastWatchedSliderSliderState extends State<LastWatchedSliderSlider> {
  PageController _controller;
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Consumer<LastWatchedProvider>(
      builder: (context, provider, child) {
        if (!provider.hasData()) return Container();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: 15.0,
                left: 15.0,
                right: 15.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recently Watched".toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      fontSize: 17.0,
                    ),
                  ),
                  CirclePageIndicator(
                    itemCount: provider.lastWatchedAnimes.length,
                    currentPageNotifier: _currentPageNotifier,
                  ),
                ],
              ),
            ),
            Container(
              height: orientation == Orientation.portrait
                  ? height * 0.25
                  : height * 0.4,
              child: PageView.builder(
                controller: _controller,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  // Since the lastWatchedAnimes are stored from oldest first to
                  // newest last, reverse the list so that the latest watched
                  // anime is shown first. Maybe do this in the service itself
                  // but fine here for now.
                  List<LastWatchedModel> lastWatchedAnimes =
                      provider.lastWatchedAnimes.reversed.toList();

                  return LastWatchedCard(
                      lastWatchedModel: lastWatchedAnimes[index]);
                },
                onPageChanged: (index) {
                  _currentPageNotifier.value = index;
                },
                itemCount: provider.lastWatchedAnimes.length,
              ),
            ),
          ],
        );
      },
    );
  }
}
