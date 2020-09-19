// Flutter imports:
import 'package:AnimeTwistFlut/animations/Transitions.dart';
import 'package:AnimeTwistFlut/models/RecentlyWatchedModel.dart';
import 'package:AnimeTwistFlut/pages/all_anime_page/AllAnimePage.dart';
import 'package:AnimeTwistFlut/providers/RecentlyWatchedProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Project imports:
import 'RecentlyWatchedCard.dart';

class RecentlyWatchedSlider extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RecentlyWatchedSliderState();
  }
}

class _RecentlyWatchedSliderState extends State<RecentlyWatchedSlider> {
  PageController _controller;
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;
    var containerHeight =
        orientation == Orientation.portrait ? height * 0.35 : height * 0.4;
    return Consumer<RecentlyWatchedProvider>(
      builder: (context, provider, child) {
        if (!provider.hasData())
          return Container(
            width: double.infinity,
            height: containerHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Image.network(
                    'https://wallpaperset.com/w/full/9/1/1/470069.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).accentColor.withOpacity(0.6),
                          Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.85),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: orientation == Orientation.portrait
                      ? height * 0.27
                      : width * 0.225,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                    ),
                    child: Text(
                      "Recently Watched".toUpperCase(),
                      style: TextStyle(
                        letterSpacing: 1.25,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.0,
                  ),
                  child: Text(
                    "Looks like you haven't watched anything yet!",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    // minFontSize: 17.0,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                ),
                Positioned(
                  bottom: orientation == Orientation.portrait
                      ? height * 0.03
                      : width * 0.225,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Start Watching".toUpperCase(),
                          style: TextStyle(
                            letterSpacing: 1.25,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12.0,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Transitions.slideTransition(
                          context: context,
                          pageBuilder: () => AllAnimePage(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        return Stack(
          children: [
            Container(
              height: containerHeight,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    controller: _controller,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      // Since the lastWatchedAnimes are stored from oldest first to
                      // newest last, reverse the list so that the latest watched
                      // anime is shown first. Maybe do this in the service itself
                      // but fine here for now.
                      List<RecentlyWatchedModel> lastWatchedAnimes =
                          provider.recentlyWatchedAnimes.reversed.toList();

                      return RecentlyWatchedCard(
                          lastWatchedModel: lastWatchedAnimes[index]);
                    },
                    onPageChanged: (index) {
                      setState(() {
                        _currentPageNotifier.value = index;
                      });
                    },
                    itemCount: provider.recentlyWatchedAnimes.length,
                  ),
                  Positioned(
                    bottom: orientation == Orientation.portrait
                        ? height * 0.26
                        : width * 0.225,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                      ),
                      child: Text(
                        "Recently Watched".toUpperCase(),
                        style: TextStyle(
                          letterSpacing: 1.25,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.05,
                    child: AnimatedSmoothIndicator(
                      activeIndex: _currentPageNotifier.value,
                      count: provider.recentlyWatchedAnimes.length,
                      effect: WormEffect(
                        dotColor: Theme.of(context).hintColor,
                        activeDotColor: Colors.white,
                        dotWidth: 8.0,
                        dotHeight: 8.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
