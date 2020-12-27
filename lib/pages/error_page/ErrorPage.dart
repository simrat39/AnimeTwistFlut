import 'package:anime_twist_flut/pages/homepage/AppbarText.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatefulWidget {
  ErrorPage(
      {Key key,
      @required this.message,
      @required this.onRefresh,
      @required this.stackTrace})
      : super(key: key);

  final String message;
  final VoidCallback onRefresh;
  final StackTrace stackTrace;

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppbarText(custom: "error"),
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
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("More info"),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Stacktrace"),
                      scrollable: true,
                      content: Text(
                        widget.stackTrace.toString(),
                      ),
                    ),
                  );
                },
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
