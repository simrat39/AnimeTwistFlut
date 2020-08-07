// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import '../../pages/all_anime_page/AllAnimePage.dart';

class ViewAllAnimeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 400),
              pageBuilder: (context, anim, secondAnim) => AllAnimePage(),
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
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(
            horizontal: 15.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15.0,
                ),
                child: Text(
                  "View All Anime",
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(
                Icons.navigate_next,
                size: 28.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
