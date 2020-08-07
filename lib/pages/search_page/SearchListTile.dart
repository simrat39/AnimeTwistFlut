// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../models/TwistModel.dart';
import '../anime_info_page/AnimeInfoPage.dart';

class SearchListTile extends StatelessWidget {
  final TwistModel twistModel;
  final FocusNode node;

  SearchListTile({
    @required this.twistModel,
    @required this.node,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        twistModel.title,
        maxLines: 1,
      ),
      subtitle: Text(
        twistModel.altTitle == null
            ? "Season " + twistModel.season.toString()
            : twistModel.altTitle + " | Season " + twistModel.season.toString(),
        maxLines: 1,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          !twistModel.ongoing
              ? Container()
              : Text(
                  "Ongoing",
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w900,
                    fontFamily: "ProductSans",
                    fontSize: 18,
                  ),
                ),
          Icon(
            Icons.navigate_next,
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 400),
            pageBuilder: (context, anim, secondAnim) => AnimeInfoPage(
              twistModel: twistModel,
              isFromSearchPage: true,
              focusNode: node,
            ),
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
    );
  }
}
