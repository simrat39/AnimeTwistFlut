import 'package:flutter/material.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
