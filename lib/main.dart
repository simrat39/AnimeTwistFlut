// Flutter imports:
import 'package:flutter/material.dart';

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

class RootWindow extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Color bgColor = Color(0xff121217);
    Color cardColor = Color(0xff121217).withOpacity(0.3);
    Color accentColor = Color(0xffe50050);

    return MaterialApp(
      home: HomePage(),
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
  }
}
