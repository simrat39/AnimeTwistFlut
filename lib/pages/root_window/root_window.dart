import 'package:anime_twist_flut/pages/favourites_page/FavouritesPage.dart';
import 'package:anime_twist_flut/pages/homepage/HomePage.dart';
import 'package:anime_twist_flut/pages/root_window/root_window_landscape.dart';
import 'package:anime_twist_flut/pages/root_window/root_window_portrait.dart';
import 'package:anime_twist_flut/widgets/device_orientation_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class RootWindow extends StatefulWidget {
  RootWindow({Key key}) : super(key: key);

  @override
  _RootWindowState createState() => _RootWindowState();
}

class _RootWindowState extends State<RootWindow> with TickerProviderStateMixin {
  TabController _tabController;
  var pages = [HomePage(), FavouritesPage()];
  final indexProvider = StateProvider<int>((ref) => 0);

  @override
  void dispose() {
    super.dispose();

    _tabController.dispose();
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: pages.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DeviceOrientationBuilder(
      portrait: RootWindowPortrait(
        tabController: _tabController,
        pages: pages,
      ),
      landscape: RootWindowLandscape(
        indexProvider: indexProvider,
        pages: pages,
      ),
    );
  }
}
