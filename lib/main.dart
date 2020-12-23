// Flutter imports:
import 'package:anime_twist_flut/widgets/SpicyMenuSheet.dart';
import 'package:anime_twist_flut/animations/Transitions.dart';
import 'package:anime_twist_flut/animations/TwistLoadingWidget.dart';
import 'package:anime_twist_flut/exceptions/NoInternetException.dart';
import 'package:anime_twist_flut/pages/chat_page/ChatPage.dart';
import 'package:anime_twist_flut/pages/error_page/ErrorPage.dart';
import 'package:anime_twist_flut/pages/favourites_page/FavouritesPage.dart';
import 'package:anime_twist_flut/pages/homepage/AppbarText.dart';
import 'package:anime_twist_flut/pages/search_page/SearchPage.dart';
import 'package:anime_twist_flut/pages/settings_page/SettingsPage.dart';
import 'package:anime_twist_flut/providers/settings/AccentColorProvider.dart';
import 'package:anime_twist_flut/providers/FavouriteAnimeProvider.dart';
import 'package:anime_twist_flut/providers/NetworkInfoProvider.dart';
import 'package:anime_twist_flut/providers/RecentlyWatchedProvider.dart';
import 'package:anime_twist_flut/providers/ToWatchProvider.dart';
import 'package:anime_twist_flut/providers/settings/ZoomFactorProvider.dart';
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';
import 'package:anime_twist_flut/utils/GetUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:spicy_components/spicy_components.dart';

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

final accentProvider = ChangeNotifierProvider<AccentColorProvider>((ref) {
  return AccentColorProvider();
});

final zoomFactorProvider = ChangeNotifierProvider<ZoomFactorProvider>((ref) {
  return ZoomFactorProvider();
});

final indexProvider = StateProvider<int>((ref) {
  return 0;
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

class _RootWindowState extends State<RootWindow> {
  final List<String> _windowTitles = ["twist", "favourites"];
  PageController pageController;
  var pages = [
    HomePage(),
    FavouritesPage(),
  ];

  var _initDataProvider = FutureProvider.autoDispose((ref) async {
    ref.maintainState = true;

    // android: Make the navbar transparent, the actual color will be set in
    // styles.xml
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ));

    // Incase we refresh on an error
    Get.delete<TwistApiService>();

    await ref.read(accentProvider).initData();
    TwistApiService twistApiService = Get.put(TwistApiService());
    await NetworkInfoProvider().throwIfNoNetwork();
    await twistApiService.setTwistModels();
    await ref.read(recentlyWatchedProvider).initData();
    await ref.read(toWatchProvider).initData();
    await ref.read(favouriteAnimeProvider).init();
    await ref.read(zoomFactorProvider).initData();
  });

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = Color(0xff121212);
    Color cardColor = Color(0xff1e1e1e);
    Color bottomBarColor = Color(0xff2d2d2d);

    return Consumer(
      builder: (context, watch, child) {
        var accentColor = watch(accentProvider).data;
        return MaterialApp(
          home: watch(_initDataProvider).when(
            data: (v) => Consumer(
              builder: (context, watch, child) {
                var prov = watch(indexProvider);
                return Scaffold(
                  bottomNavigationBar: SpicyBottomBar(
                    leftItems: [
                      IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => SpicyMenuSheet(
                              bgColor: bottomBarColor,
                              activeColor: accentColor,
                              activeIndex: prov.state,
                              onChange: (index) {
                                prov.state = index;
                                pageController.jumpToPage(index);
                                Navigator.of(context).pop();
                              },
                              items: [
                                SpicyMenuSheetItem(
                                  text: "Home",
                                  icon: Icons.home,
                                ),
                                SpicyMenuSheetItem(
                                  text: "Favourites",
                                  icon: Icons.favorite_outline,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      AppbarText(custom: _windowTitles[prov.state]),
                    ],
                    bgColor: bottomBarColor,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    rightItems: [
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
                  ),
                  body: PageView.builder(
                    controller: pageController,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => pages[index],
                    itemCount: pages.length,
                  ),
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
              switch (e) {
                case NoInternetException:
                  message =
                      "Looks like you are not connected to the internet . Please reconnect and try again";
                  break;
              }
              return ErrorPage(
                message: message,
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
            bottomNavigationBarTheme:
                BottomNavigationBarThemeData(backgroundColor: bottomBarColor),
            appBarTheme: AppBarTheme(
              color: bgColor,
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
        );
      },
    );
  }
}
