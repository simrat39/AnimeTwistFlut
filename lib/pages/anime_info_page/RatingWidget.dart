import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../models/KitsuModel.dart';

class RatingWidget extends StatelessWidget {
  final KitsuModel kitsuModel;
  final double fontScale;

  RatingWidget({this.kitsuModel, this.fontScale = 1.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.height * 0.16,
      height: MediaQuery.of(context).size.height * 0.16,
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
