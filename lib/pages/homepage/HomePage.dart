// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../utils/TwistUtils.dart';
import '../search_page/SearchPage.dart';
import 'DonationCard.dart';
import 'MOTDCard.dart';
import 'ViewAllAnimeCard.dart';
import 'explore_slider/ExploreSlider.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  Future _getAnime;

  @override
  void initState() {
    _getAnime = TwistUtils.getAllTwistModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Icons.search,
            ),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 400),
                  pageBuilder: (context, anim, secondAnim) => SearchPage(),
                  transitionsBuilder: (context, anim, secondAnim, child) {
                    var tween = Tween(
                      begin: Offset(1.0, 0.0),
                      end: Offset.zero,
                    );
                    var curvedAnimation = CurvedAnimation(
                      parent: anim,
                      curve: Curves.ease,
                    );
                    return SlideTransition(
                      position: tween.animate(curvedAnimation),
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _getAnime,
          builder: (context, snapshot) {
            if (!(snapshot.connectionState == ConnectionState.done))
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 24.0,
                    ),
                    Text(
                      "Loading Anime!",
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Message Of The Day Card
                  Padding(
                    padding: EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                      bottom: 15.0,
                    ),
                    child: MOTDCard(),
                  ),
                  // Explore anime slider
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 15.0,
                    ),
                    child: ExploreSlider(),
                  ),
                  // View all anime card
                  Padding(
                    padding: EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                      bottom: 15.0,
                    ),
                    child: ViewAllAnimeCard(),
                  ),
                  // Donation Card
                  Padding(
                    padding: EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                      bottom: 15.0,
                    ),
                    child: DonationCard(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
