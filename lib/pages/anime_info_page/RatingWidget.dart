import 'package:anime_twist_flut/models/kitsu/KitsuModel.dart';
import 'package:anime_twist_flut/pages/anime_info_page/RatingGraph.dart';
import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({Key key, @required this.kitsuModel}) : super(key: key);

  final KitsuModel kitsuModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(
          right: 20.0,
        ),
        decoration: BoxDecoration(
          color: Color(0xfff8f8f2),
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(
              20.0,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: RatingGraph(
                    ratingFrequencies: kitsuModel.ratingFrequencies,
                  ),
                  // contentPadding: EdgeInsets.zero,
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Close"),
                    ),
                  ],
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 6.0,
              ),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.star,
                      color: Colors.pink,
                    ),
                  ),
                  Text(
                    (kitsuModel?.rating?.toString() ?? "??") + " / 100",
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
