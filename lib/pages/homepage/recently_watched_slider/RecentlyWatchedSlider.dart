// Flutter imports:
import 'package:anime_twist_flut/animations/Transitions.dart';
import 'package:anime_twist_flut/main.dart';
import 'package:anime_twist_flut/models/RecentlyWatchedModel.dart';
import 'package:anime_twist_flut/pages/all_anime_page/AllAnimePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:anime_twist_flut/constants.dart';

// Project imports:
import 'RecentlyWatchedCard.dart';

class RecentlyWatchedSlider extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RecentlyWatchedSliderState();
  }
}

final offsetProvider = StateProvider<double>((ref) {
  return 0.0;
});

class _RecentlyWatchedSliderState extends State<RecentlyWatchedSlider> {
  PageController _controller;
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    _controller = PageController();
    _controller.addListener(() {
      double offset = _controller.page - _controller.page.floor();
      context.read(offsetProvider).state = offset;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;
    double topInset = MediaQuery.of(context).viewPadding.top;

    var containerHeight =
        orientation == Orientation.portrait ? height * 0.4 : width * 0.3;
    return Consumer(
      builder: (context, watch, child) {
        final provider = watch(recentlyWatchedProvider);
        if (!provider.hasData()) {
          return Container(
            width: double.infinity,
            height: containerHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Image.network(
                    DEFAULT_IMAGE_URL,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Color(0xff070E30).withOpacity(0.7),
                  ),
                ),
                Positioned(
                  bottom: orientation == Orientation.portrait
                      ? height * 0.3
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
                      : width * 0.03,
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
        }
        return Stack(
          children: [
            Container(
              height: containerHeight + topInset,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    controller: _controller,
                    itemBuilder: (context, index) {
                      // Since the lastWatchedAnimes are stored from oldest first to
                      // newest last, reverse the list so that the latest watched
                      // anime is shown first. Maybe do this in the service itself
                      // but fine here for now.
                      List<RecentlyWatchedModel> lastWatchedAnimes =
                          provider.recentlyWatchedAnimes.reversed.toList();

                      return RecentlyWatchedCard(
                        lastWatchedModel: lastWatchedAnimes[index],
                        pageNum: index,
                        pageController: _controller,
                      );
                    },
                    onPageChanged: (index) {
                      setState(() {
                        _currentPageNotifier.value = index;
                      });
                    },
                    itemCount: provider.recentlyWatchedAnimes.length,
                  ),
                  Positioned(
                    bottom: (orientation == Orientation.portrait
                            ? height * 0.3
                            : width * 0.23) +
                        topInset / 2,
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
