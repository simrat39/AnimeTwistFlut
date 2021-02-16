// Flutter imports:
import 'package:anime_twist_flut/constants.dart';
import 'package:anime_twist_flut/pages/anime_info_page/AnimeInfoPage.dart';
import 'package:flutter/material.dart';

// Project imports:
import '../../../animations/Transitions.dart';
import '../../../models/kitsu/KitsuModel.dart';
import '../../../models/TwistModel.dart';

class ExploreRowItem extends StatefulWidget {
  final TwistModel twistModel;
  final KitsuModel kitsuModel;

  ExploreRowItem({this.twistModel, this.kitsuModel});

  @override
  State<StatefulWidget> createState() {
    return _ExploreRowItemState();
  }
}

class _ExploreRowItemState extends State<ExploreRowItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          8.0,
        ),
        child: Stack(
          children: [
            Image.network(
              widget.kitsuModel?.posterImage ?? DEFAULT_IMAGE_URL,
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(onTap: () {
                  Transitions.slideTransition(
                    context: context,
                    pageBuilder: () => AnimeInfoPage(
                      twistModel: widget.twistModel,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
