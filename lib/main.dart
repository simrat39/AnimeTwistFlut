// Flutter imports:
import 'package:anime_twist_flut/animations/TwistLoadingWidget.dart';
import 'package:anime_twist_flut/exceptions/NoInternetException.dart';
import 'package:anime_twist_flut/exceptions/TwistDownException.dart';
import 'package:anime_twist_flut/pages/error_page/ErrorPage.dart';
import 'package:anime_twist_flut/pages/root_window/root_window.dart';
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
import 'dart:io' show Platform;

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
  runApp(ProviderScope(child: MainWidget()));
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

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget>
    with SingleTickerProviderStateMixin {
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

    await ref.read(zoomFactorProvider).initalize();
    await ref.read(doubleTapDurationProvider).initalize();
    await ref.read(playbackSpeeedProvider).initalize();
    await ref.read(tvInfoProvider).initialize();
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = Color(0xff121212);
    Color cardColor = Color(0xff1D1D1D);
    Color bottomNavbarColor = Color(0xff1f1f1f);

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
                builder: (context, watch, child) => RootWindow(),
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
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: bottomNavbarColor,
                elevation: 8.0,
                showSelectedLabels: true,
                showUnselectedLabels: false,
              ),
              scrollbarTheme: ScrollbarThemeData(
                thickness: MaterialStateProperty.all(4),
                showTrackOnHover: true,
                trackColor: MaterialStateProperty.all(cardColor),
                trackBorderColor: MaterialStateProperty.all(cardColor),
                isAlwaysShown:
                    Platform.isLinux || Platform.isWindows || Platform.isMacOS,
              ),
            ),
            themeMode: ThemeMode.dark,
          ),
        );
      },
    );
  }
}
