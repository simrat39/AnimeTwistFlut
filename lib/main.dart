// Flutter imports:
import 'package:anime_twist_flut/animations/Transitions.dart';
import 'package:anime_twist_flut/animations/TwistLoadingWidget.dart';
import 'package:anime_twist_flut/exceptions/NoInternetException.dart';
import 'package:anime_twist_flut/exceptions/TwistDownException.dart';
import 'package:anime_twist_flut/pages/chat_page/ChatPage.dart';
import 'package:anime_twist_flut/pages/error_page/ErrorPage.dart';
import 'package:anime_twist_flut/pages/favourites_page/FavouritesPage.dart';
import 'package:anime_twist_flut/pages/homepage/AppbarText.dart';
import 'package:anime_twist_flut/pages/search_page/SearchPage.dart';
import 'package:anime_twist_flut/pages/settings_page/SettingsPage.dart';
import 'package:anime_twist_flut/providers/TVInfoProvider.dart';
import 'package:anime_twist_flut/providers/settings/AccentColorProvider.dart';
import 'package:anime_twist_flut/providers/FavouriteAnimeProvider.dart';
import 'package:anime_twist_flut/providers/NetworkInfoProvider.dart';
import 'package:anime_twist_flut/providers/RecentlyWatchedProvider.dart';
import 'package:anime_twist_flut/providers/ToWatchProvider.dart';
import 'package:anime_twist_flut/providers/settings/DoubleTapDuration.dart';
import 'package:anime_twist_flut/providers/settings/PlaybackSpeedProvider.dart';
import 'package:anime_twist_flut/providers/settings/ZoomFactorProvider.dart';
import 'package:anime_twist_flut/services/SharedPreferencesManager.dart';
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';
import 'package:anime_twist_flut/utils/GetUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';

// Project imports:
import 'pages/homepage/HomePage.dart';

class CustomImageCache extends WidgetsFlutterBinding {
  @override
  ImageCache createImageCache() {
    ImageCache imageCache = super.createImageCache();
    // Set your image cache size
    imageCache.maximumSizeBytes = 1024 * 1024 * 1024; // 1 GB
    imageCache.maximumSize = 1000; // 1000 Items
    return imageCache;
  }
}

void main() {
  CustomImageCache();
  runApp(ProviderScope(child: RootWindow()));
}

final sharedPreferencesProvider = Provider<SharedPreferencesManager>((ref) {
  return SharedPreferencesManager();
});

final tvInfoProvider = Provider<TVInfoProvider>((ref) {
  return TVInfoProvider();
});

final accentProvider = ChangeNotifierProvider<AccentColorProvider>((ref) {
  return AccentColorProvider(ref.read(sharedPreferencesProvider));
});

final zoomFactorProvider = ChangeNotifierProvider<ZoomFactorProvider>((ref) {
  return ZoomFactorProvider(ref.read(sharedPreferencesProvider));
});

final doubleTapDurationProvider =
    ChangeNotifierProvider<DoubleTapDurationProvider>((ref) {
  return DoubleTapDurationProvider(ref.read(sharedPreferencesProvider));
});

final playbackSpeeedProvider =
    ChangeNotifierProvider<PlaybackSpeedProvider>((ref) {
  return PlaybackSpeedProvider(ref.read(sharedPreferencesProvider));
});

final recentlyWatchedProvider =
    ChangeNotifierProvider<RecentlyWatchedProvider>((ref) {
  return RecentlyWatchedProvider();
});

final toWatchProvider = ChangeNotifierProvider<ToWatchProvider>((ref) {
  return ToWatchProvider();
});

final favouriteAnimeProvider = ChangeNotifierProvider<FavouriteAnimeProvider>(
    (ref) => FavouriteAnimeProvider());

class RootWindow extends StatefulWidget {
  @override
  _RootWindowState createState() => _RootWindowState();
}

class _RootWindowState extends State<RootWindow>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  var pages = [HomePage(), FavouritesPage()];

  var _initDataProvider = FutureProvider.autoDispose((ref) async {
    ref.maintainState = true;

    // android: Make the navbar transparent, the actual color will be set in
    // styles.xml
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ));

    // Incase we refresh on an error
    Get.delete<TwistApiService>();

    await ref.read(sharedPreferencesProvider).initialize();

    await ref.read(accentProvider).initalize();
    TwistApiService twistApiService = Get.put(TwistApiService());
    await NetworkInfoProvider().throwIfNoNetwork();
    await twistApiService.setTwistModels();
    await ref.read(recentlyWatchedProvider).initialize();
    await ref.read(toWatchProvider).initialize();
    await ref.read(favouriteAnimeProvider).initialize();

    // dont be blocking
    ref.read(zoomFactorProvider).initalize();
    ref.read(doubleTapDurationProvider).initalize();
    ref.read(playbackSpeeedProvider).initalize();
    ref.read(tvInfoProvider).initialize();
  });

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: pages.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = Color(0xff121212);
    Color cardColor = Color(0xff11D1D1D);

    return Consumer(
      builder: (context, watch, child) {
        var accentColor = watch(accentProvider).value;
        return Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
          },
          child: MaterialApp(
            home: watch(_initDataProvider).when(
              data: (v) => Consumer(
                builder: (context, watch, child) {
                  return Scaffold(
                    body: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          primary: true,
                          bottom: TabBar(
                            controller: _tabController,
                            indicatorColor: Theme.of(context).accentColor,
                            tabs: [
                              Tab(icon: Icon(Icons.home)),
                              Tab(icon: Icon(Icons.favorite_outline)),
                            ],
                          ),
                          title: AppbarText(),
                          actions: [
                            IconButton(
                              icon: Icon(
                                Icons.settings,
                              ),
                              onPressed: () {
                                Transitions.slideTransition(
                                  context: context,
                                  pageBuilder: () => SettingsPage(),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.chat_bubble,
                              ),
                              onPressed: () {
                                Transitions.slideTransition(
                                  context: context,
                                  pageBuilder: () => ChatPage(),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.search,
                              ),
                              onPressed: () {
                                Transitions.slideTransition(
                                  context: context,
                                  pageBuilder: () => SearchPage(),
                                );
                              },
                            ),
                          ],
                          pinned: true,
                          floating: true,
                          snap: true,
                        ),
                        SliverFillRemaining(
                          child: TabBarView(
                            controller: _tabController,
                            children: pages,
                          ),
                        ),
                      ],
                    ),
                    // body: NestedScrollView(
                    //   floatHeaderSlivers: true,
                    //   headerSliverBuilder: (context, innerBoxIsScrolled) {
                    //     return [
                    //       SliverOverlapAbsorber(
                    //         handle:
                    //             NestedScrollView.sliverOverlapAbsorberHandleFor(
                    //           context,
                    //         ),
                    //         sliver: SliverAppBar(
                    //           primary: true,
                    //           bottom: TabBar(
                    //             controller: _tabController,
                    //             indicatorColor: Theme.of(context).accentColor,
                    //             tabs: [
                    //               Tab(icon: Icon(Icons.home)),
                    //               Tab(icon: Icon(Icons.favorite_outline)),
                    //             ],
                    //           ),
                    //           title: AppbarText(),
                    //           actions: [
                    //             IconButton(
                    //               icon: Icon(
                    //                 Icons.settings,
                    //               ),
                    //               onPressed: () {
                    //                 Transitions.slideTransition(
                    //                   context: context,
                    //                   pageBuilder: () => SettingsPage(),
                    //                 );
                    //               },
                    //             ),
                    //             IconButton(
                    //               icon: Icon(
                    //                 Icons.chat_bubble,
                    //               ),
                    //               onPressed: () {
                    //                 Transitions.slideTransition(
                    //                   context: context,
                    //                   pageBuilder: () => ChatPage(),
                    //                 );
                    //               },
                    //             ),
                    //             IconButton(
                    //               icon: Icon(
                    //                 Icons.search,
                    //               ),
                    //               onPressed: () {
                    //                 Transitions.slideTransition(
                    //                   context: context,
                    //                   pageBuilder: () => SearchPage(),
                    //                 );
                    //               },
                    //             ),
                    //           ],
                    //           pinned: true,
                    //           floating: true,
                    //           snap: true,
                    //         ),
                    //       ),
                    //     ];
                    //   },
                    //   body: TabBarView(
                    //     controller: _tabController,
                    //     children: pages,
                    //   ),
                    // ),
                  );
                },
              ),
              loading: () {
                return Scaffold(
                  body: Center(
                    child: RotatingPinLoadingAnimation(),
                  ),
                );
              },
              error: (e, s) {
                var message = 'Whoops! An error occured';
                if (e is NoInternetException) {
                  message =
                      "Looks like you are not connected to the internet. Please reconnect and try again";
                } else if (e is TwistDownException) {
                  message =
                      "Looks like twist.moe is down. Please try again later";
                }
                return ErrorPage(
                  message: message,
                  e: e,
                  stackTrace: s,
                  onRefresh: () => context.refresh(_initDataProvider),
                );
              },
            ),
            darkTheme: ThemeData.dark().copyWith(
              cardColor: cardColor,
              scaffoldBackgroundColor: bgColor,
              dialogBackgroundColor: bgColor,
              accentColor: accentColor,
              toggleableActiveColor: accentColor,
              appBarTheme: AppBarTheme(
                color: bgColor,
                elevation: 0.0,
              ),
              cardTheme: CardTheme(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: ButtonStyleButton.allOrNull<Color>(
                    accentColor,
                  ),
                  overlayColor: ButtonStyleButton.allOrNull<Color>(
                    accentColor.withOpacity(0.2),
                  ),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(primary: accentColor)),
              bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: bgColor,
              ),
            ),
            themeMode: ThemeMode.dark,
          ),
        );
      },
    );
  }
}
