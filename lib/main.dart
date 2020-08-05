import 'package:flutter/material.dart';
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

class RootWindow extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData.light().copyWith(
        accentColor: Color(0xff69f0ae),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        appBarTheme: AppBarTheme(
          color: Color(0xffffffff),
          elevation: 0.0,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        cardColor: Color(0xff262845),
        scaffoldBackgroundColor: Color(0xff1d1f3e),
        accentColor: Color(0xff69f0ae),
        appBarTheme: AppBarTheme(
          color: Color(0xff1d1f3e),
          elevation: 0.0,
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          margin: EdgeInsets.zero,
        ),
      ),
      themeMode: ThemeMode.dark,
    );
  }
}
