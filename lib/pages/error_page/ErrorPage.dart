import 'package:anime_twist_flut/pages/homepage/AppbarText.dart';
import 'package:anime_twist_flut/widgets/GoBackButton.dart';
import 'package:flutter/material.dart';
import 'package:spicy_components/spicy_components.dart';

class ErrorPage extends StatefulWidget {
  ErrorPage({Key key, @required this.message, @required this.onRefresh})
      : super(key: key);

  final String message;
  final VoidCallback onRefresh;

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SpicyBottomBar(
        leftItems: [
          GoBackButton(),
          AppbarText(custom: "error"),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.message,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Retry"),
                onPressed: widget.onRefresh,
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).accentColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
