import 'package:flutter/material.dart';

class HomePageLandscape extends StatelessWidget {
  final List<Widget> widgets;

  const HomePageLandscape({Key key, @required this.widgets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: 4,
            itemBuilder: (context, index) => widgets.elementAt(index),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widgets.length - 4,
            itemBuilder: (context, index) => widgets.elementAt(index + 4),
          ),
        ),
      ],
    );
  }
}
