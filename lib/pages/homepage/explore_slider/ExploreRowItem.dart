// Flutter imports:
import 'package:AnimeTwistFlut/pages/anime_info_page/AnimeInfoPage.dart';
import 'package:flutter/material.dart';

// Project imports:
import '../../../animations/Transitions.dart';
import '../../../models/KitsuModel.dart';
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
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.4,
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
              widget.kitsuModel.imageURL,
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(onTap: () {
                  Transitions.slideTransition(
                    context: context,
                    pageBuilder: () => AnimeInfoPage(
                      twistModel: widget.twistModel,
                      kitsuModel: widget.kitsuModel,
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
