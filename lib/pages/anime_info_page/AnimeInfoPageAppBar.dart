// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../../animations/Transitions.dart';
import '../../models/TwistModel.dart';
import '../../utils/anime_info_page/MALUtils.dart';
import '../search_page/SearchPage.dart';

class AnimeInfoPageAppBar {
  final bool isFromSearchPage;
  final TwistModel twistModel = Get.find();

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
        twistModel.malId != null
            ? IconButton(
                icon: Icon(
                  Icons.info_outline_rounded,
                ),
                onPressed: () {
                  MALUtils.launchMalLink(twistModel.malId);
                },
              )
            : Container(),
        IconButton(
          icon: Icon(
            Icons.search,
          ),
          onPressed: () {
            if (isFromSearchPage ?? false) {
              Navigator.pop(context);
            } else {
              Transitions.slideTransition(
                context: context,
                pageBuilder: () => SearchPage(),
              );
            }
          },
        ),
      ],
    );
  }
}
