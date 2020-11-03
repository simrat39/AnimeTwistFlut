// Flutter imports:
import 'package:anime_twist_flut/animations/Transitions.dart';
import 'package:anime_twist_flut/pages/chat_page/ChatPage.dart';
import 'package:anime_twist_flut/pages/favourites_page/FavouritesPage.dart';
import 'package:anime_twist_flut/pages/homepage/AppbarText.dart';
import 'package:anime_twist_flut/pages/search_page/SearchPage.dart';
import 'package:anime_twist_flut/pages/settings_page/SettingsPage.dart';
import 'package:anime_twist_flut/providers/AccentColorProvider.dart';
import 'package:flutter/material.dart';
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

final accentProvider = ChangeNotifierProvider<AccentColorProvider>((ref) {
  return AccentColorProvider();
});

final indexProvider = StateProvider<int>((ref) {
  return 0;
});

class RootWindow extends StatelessWidget {
  final List<String> _windowTitles = ["twist", "favourites"];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Color bgColor = Color(0xff121212);
    Color cardColor = Color(0xff11D1D1D);

    return Consumer(
      builder: (context, watch, child) {
        var accentColor = watch(accentProvider).color;
        return MaterialApp(
          home: Consumer(
            builder: (context, watch, child) {
              var prov = watch(indexProvider);
              return Scaffold(
                appBar: AppBar(
                  title: AppbarText(custom: _windowTitles[prov.state]),
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
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: prov.state,
                  onTap: (index) => prov.state = index,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: "Home",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite_outline),
                      label: "Favourites",
                    ),
                  ],
                ),
                body: IndexedStack(
                  index: prov.state,
                  children: [
                    HomePage(),
                    FavouritesPage(),
                  ],
                ),
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
