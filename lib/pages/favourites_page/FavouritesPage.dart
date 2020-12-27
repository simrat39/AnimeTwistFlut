import 'package:anime_twist_flut/animations/SlideInAnimation.dart';
import 'package:anime_twist_flut/animations/Transitions.dart';
import 'package:anime_twist_flut/main.dart';
import 'package:anime_twist_flut/models/FavouritedModel.dart';
import 'package:anime_twist_flut/pages/anime_info_page/AnimeInfoPage.dart';
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';
import 'package:anime_twist_flut/utils/GetUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key key}) : super(key: key);

  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage>
    with AutomaticKeepAliveClientMixin {
  TwistApiService twistApiService = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer(
      builder: (context, watch, child) {
        var prov = watch(favouriteAnimeProvider);
        List<FavouritedModel> favouritedAnimes =
            prov.favouritedAnimes.reversed.toList();

        if (favouritedAnimes.isEmpty) {
          return SlideInAnimation(
            child: Center(
              child: Icon(
                FontAwesomeIcons.heartBroken,
                size: 75,
              ),
            ),
          );
        }
        return Scrollbar(
          thickness: 4,
          child: CustomScrollView(
            slivers: [
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var model = twistApiService
                        .getTwistModelFromSlug(favouritedAnimes[index].slug);

                    return ListTile(
                      title: Text(model.title),
                      subtitle: Text("Season " + model.season.toString()),
                      trailing: IconButton(
                        icon: Icon(Icons.favorite),
                        onPressed: () => prov.removeFromFavourites(model.slug),
                      ),
                      onTap: () => Transitions.slideTransition(
                          context: context,
                          pageBuilder: () {
                            return AnimeInfoPage(
                              twistModel: model,
                            );
                          }),
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(favouritedAnimes[index].coverURL),
                      ),
                    );
                  },
                  childCount: favouritedAnimes.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
