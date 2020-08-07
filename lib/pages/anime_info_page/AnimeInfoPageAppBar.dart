// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../search_page/SearchPage.dart';

class AnimeInfoPageAppBar {
  final bool isFromSearchPage;

  AnimeInfoPageAppBar({
    @required this.isFromSearchPage,
  });

  Widget build(BuildContext context) {
    return AppBar(
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
            if (isFromSearchPage ?? false) {
              Navigator.pop(context);
            } else {
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
            }
          },
        ),
      ],
    );
  }
}
