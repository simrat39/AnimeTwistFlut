import 'package:anime_twist_flut/animations/FadeThroughIndexedStack.dart';
import 'package:anime_twist_flut/animations/Transitions.dart';
import 'package:anime_twist_flut/pages/chat_page/ChatPage.dart';
import 'package:anime_twist_flut/pages/homepage/AppbarText.dart';
import 'package:anime_twist_flut/pages/search_page/SearchPage.dart';
import 'package:anime_twist_flut/pages/settings_page/SettingsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class RootWindowLandscape extends StatelessWidget {
  const RootWindowLandscape({
    Key key,
    @required this.indexProvider,
    @required this.pages,
  }) : super(key: key);

  final StateProvider indexProvider;
  final List<Widget> pages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        primary: true,
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
      ),
      body: Consumer(
        builder: (context, watch, child) {
          var prov = watch(indexProvider);
          return Row(
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: Theme.of(context).accentColor,
                  ),
                ),
                child: NavigationRail(
                  onDestinationSelected: (index) => prov.state = index,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  selectedIconTheme: IconThemeData(
                    color: Theme.of(context).accentColor,
                  ),
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text("Home"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite_outline),
                      selectedIcon: Icon(Icons.favorite),
                      label: Text("Favorites"),
                    )
                  ],
                  selectedIndex: prov.state,
                ),
              ),
              VerticalDivider(
                thickness: 1,
                width: 1,
                indent: 0.0,
                endIndent: 0.0,
              ),
              Expanded(
                child: FadeThroughIndexedStack(
                  index: prov.state,
                  children: pages,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
