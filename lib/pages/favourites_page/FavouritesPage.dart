import 'package:anime_twist_flut/animations/SlideInAnimation.dart';
import 'package:anime_twist_flut/animations/Transitions.dart';
import 'package:anime_twist_flut/main.dart';
import 'package:anime_twist_flut/models/KitsuModel.dart';
import 'package:anime_twist_flut/models/TwistModel.dart';
import 'package:anime_twist_flut/pages/anime_info_page/AnimeInfoPage.dart';
import 'package:anime_twist_flut/providers/FavouriteAnimeProvider.dart';
import 'package:anime_twist_flut/services/KitsuApiService.dart';
import 'package:flutter/material.dart';
import 'package:change_notifier_listener/change_notifier_listener.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key key}) : super(key: key);

  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  Future<KitsuModel> _getKitsuModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierListener<FavouriteAnimeProvider>(
      changeNotifier: favouriteAnimeProvider,
      builder: (context, notifier) {
        List<TwistModel> models =
            notifier.getTwistModelsForFavs().reversed.toList();

        if (models.isEmpty) {
          return SlideInAnimation(
            child: Center(
              child: Icon(
                FontAwesomeIcons.heartBroken,
                size: 75,
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: models.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            var model = models[index];
            _getKitsuModel = KitsuApiService().getKitsuModel(model.kitsuId);

            return ListTile(
              title: Text(model.title),
              subtitle: Text("Season " + model.season.toString()),
              trailing: IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () => notifier.toggleFromFavs(model.slug),
              ),
              onTap: () => Transitions.slideTransition(
                  context: context,
                  pageBuilder: () {
                    return AnimeInfoPage(
                      twistModel: model,
                    );
                  }),
              leading: FutureBuilder(
                future: _getKitsuModel,
                builder: (context, AsyncSnapshot<KitsuModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data.posterImage),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
