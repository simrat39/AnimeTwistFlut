// Flutter imports:
import 'package:anime_twist_flut/animations/FadeThroughIndexedStack.dart';
import 'package:anime_twist_flut/animations/Transitions.dart';
import 'package:anime_twist_flut/pages/chat_page/ChatPage.dart';
import 'package:anime_twist_flut/pages/favourites_page/FavouritesPage.dart';
import 'package:anime_twist_flut/pages/homepage/AppbarText.dart';
import 'package:anime_twist_flut/pages/search_page/SearchPage.dart';
import 'package:anime_twist_flut/pages/settings_page/SettingsPage.dart';
import 'package:anime_twist_flut/providers/AccentColorProvider.dart';
import 'package:anime_twist_flut/providers/FavouriteAnimeProvider.dart';
import 'package:anime_twist_flut/providers/RecentlyWatchedProvider.dart';
import 'package:anime_twist_flut/providers/ToWatchProvider.dart';
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';
import 'package:anime_twist_flut/utils/GetUtils.dart';
import 'package:flutter/material.dart';
import 'package:change_notifier_listener/change_notifier_listener.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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
  runApp(RootWindow());
}

final accentProvider = AccentColorProvider();

final indexProvider = ValueNotifier(0);

final recentlyWatchedProvider = RecentlyWatchedProvider();

final toWatchProvider = ToWatchProvider();

final favouriteAnimeProvider = FavouriteAnimeProvider();

class RootWindow extends StatefulWidget {
  @override
  _RootWindowState createState() => _RootWindowState();
}

class _RootWindowState extends State<RootWindow> {
  final List<String> _windowTitles = ["twist", "favourites"];
  Future _initData;

  Future initData() async {
    TwistApiService twistApiService = Get.put(TwistApiService());
    await accentProvider.initData();
    await twistApiService.setTwistModels();
    await recentlyWatchedProvider.initData();
    await toWatchProvider.initData();
    await favouriteAnimeProvider.init();
  }

  @override
  void initState() {
    _initData = initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = Color(0xff121212);
    Color cardColor = Color(0xff11D1D1D);

    return ChangeNotifierListener<AccentColorProvider>(
      changeNotifier: accentProvider,
      builder: (context, notifier) {
        var accentColor = notifier.color;
        return MaterialApp(
          home: FutureBuilder(
            future: _initData,
            builder: (context, snapshot) {
              if (!(snapshot.connectionState == ConnectionState.done))
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 24.0,
                        ),
                        Text(
                          "Loading Anime!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              return ChangeNotifierListener<ValueNotifier<int>>(
                changeNotifier: indexProvider,
                builder: (context, notifier) {
                  return Scaffold(
                    appBar: AppBar(
                      title: AppbarText(custom: _windowTitles[notifier.value]),
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
                    ),
                    bottomNavigationBar: Container(
                      color: Theme.of(context).cardColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 8),
                        child: GNav(
                            gap: 8,
                            activeColor: Theme.of(context)
                                        .accentColor
                                        .computeLuminance() >
                                    0.5
                                ? Colors.black
                                : Colors.white,
                            iconSize: 24,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            duration: Duration(milliseconds: 500),
                            tabBackgroundColor:
                                Theme.of(context).accentColor.withOpacity(0.8),
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            tabs: [
                              GButton(
                                icon: Icons.home_outlined,
                                text: 'Home',
                              ),
                              GButton(
                                icon: Icons.favorite_outline,
                                text: 'Favorites',
                              ),
                            ],
                            selectedIndex: notifier.value,
                            onTabChange: (index) {
                              notifier.value = index;
                            }),
                      ),
                    ),
                    body: FadeThroughIndexedStack(
                      index: notifier.value,
                      children: [
                        HomePage(),
                        FavouritesPage(),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          darkTheme: ThemeData.dark().copyWith(
            cardColor: cardColor,
            scaffoldBackgroundColor: bgColor,
            dialogBackgroundColor: bgColor,
            accentColor: accentColor,
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
