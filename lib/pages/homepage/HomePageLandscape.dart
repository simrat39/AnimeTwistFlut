import 'package:flutter/material.dart';

class HomePageLandscape extends StatelessWidget {
  final List<Widget> widgets;

  const HomePageLandscape({Key key, @required this.widgets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => widgets.elementAt(index),
                  childCount: 4,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => widgets.elementAt(index + 4),
                  childCount: widgets.length - 4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
