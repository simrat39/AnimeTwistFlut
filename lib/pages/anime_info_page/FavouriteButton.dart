import 'package:anime_twist_flut/main.dart';
import 'package:anime_twist_flut/models/TwistModel.dart';
import 'package:anime_twist_flut/providers/FavouriteAnimeProvider.dart';
import 'package:flutter/material.dart';
import 'package:change_notifier_listener/change_notifier_listener.dart';

class FavouriteButton extends StatelessWidget {
  const FavouriteButton({Key key, @required this.twistModel}) : super(key: key);

  final TwistModel twistModel;

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Color accentColor = Theme.of(context).accentColor;
    var side =
        orientation == Orientation.portrait ? height * 0.06 : width * 0.06;

    return Container(
      margin: EdgeInsets.only(
        right: 16.0,
        top: 25.0,
        bottom: 20.0,
      ),
      height: side,
      width: side,
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(
          8.0,
        ),
      ),
      child: ChangeNotifierListener<FavouriteAnimeProvider>(
        changeNotifier: favouriteAnimeProvider,
        builder: (context, notifier) {
          bool isFav = notifier.isSlugInFavourites(twistModel.slug);

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => notifier.toggleFromFavs(twistModel.slug),
              child: Icon(
                isFav ? Icons.favorite : Icons.favorite_outline,
                color: accentColor.computeLuminance() < 0.5
                    ? Colors.white
                    : Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
