// Flutter imports:
import '../../animations/Transitions.dart';
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
        Transitions.slideTransition(
          context: context,
          pageBuilder: () => AnimeInfoPage(
            twistModel: twistModel,
            isFromSearchPage: true,
            focusNode: node,
          ),
        );
      },
    );
  }
}
