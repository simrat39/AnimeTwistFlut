import 'package:flutter/material.dart';

class SubCategoryText extends StatelessWidget {
  const SubCategoryText({
    Key key,
    this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
