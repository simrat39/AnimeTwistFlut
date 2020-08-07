// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';

// Project imports:
import '../../models/KitsuModel.dart';

class RatingWidget extends StatelessWidget {
  final KitsuModel kitsuModel;
  final double fontScale;

  RatingWidget({this.kitsuModel, this.fontScale = 1.0});

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    double sideLen = orientation == Orientation.portrait
        ? MediaQuery.of(context).size.height * 0.16
        : MediaQuery.of(context).size.width * 0.16;
    return Container(
      width: sideLen,
      height: sideLen,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.yellow,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(
        15.0,
      ),
      child: Center(
        child: AutoSizeText(
          kitsuModel.rating != null
              ? kitsuModel.rating.substring(
                    0,
                    kitsuModel.rating.indexOf('.'),
                  ) +
                  "%"
              : "?",
          maxLines: 1,
          minFontSize: 30.0,
          maxFontSize: 60.0,
          style: TextStyle(
            color: Colors.yellow,
            fontSize: 60.0,
            fontWeight: FontWeight.bold,
            fontFamily: "ProductSans",
          ),
        ),
      ),
    );
  }
}
