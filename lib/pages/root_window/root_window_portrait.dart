import 'package:anime_twist_flut/animations/Transitions.dart';
import 'package:anime_twist_flut/pages/chat_page/ChatPage.dart';
import 'package:anime_twist_flut/pages/homepage/AppbarText.dart';
import 'package:anime_twist_flut/pages/search_page/SearchPage.dart';
import 'package:anime_twist_flut/pages/settings_page/SettingsPage.dart';
import 'package:flutter/material.dart';

class RootWindowPortrait extends StatelessWidget {
  RootWindowPortrait({
    Key key,
    @required this.tabController,
    @required this.pages,
  }) : super(key: key);

  final TabController tabController;
  final List<Widget> pages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        primary: true,
        bottom: TabBar(
          controller: tabController,
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
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: TabBarView(
              controller: tabController,
              children: pages,
            ),
          ),
        ],
      ),
    );
  }
}
