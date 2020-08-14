// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import '../../models/KitsuModel.dart';
import '../../models/TwistModel.dart';

class DescriptionBox extends StatelessWidget {
  final TwistModel twistModel;
  final KitsuModel kitsuModel;

  DescriptionBox({this.kitsuModel, this.twistModel});

  String getDescription() {
    if (kitsuModel != null) {
      if (twistModel.altTitle != null) {
        return twistModel.altTitle + "\n\n" + kitsuModel?.description ?? "";
      } else {
        return kitsuModel?.description ??
            "Season ${twistModel.season} of ${twistModel.title}";
      }
    } else {
      return "Season ${twistModel.season} of ${twistModel.title}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).accentColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          15.0,
        ),
        child: Text(
          getDescription(),
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }
}
