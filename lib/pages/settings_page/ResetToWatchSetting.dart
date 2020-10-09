import 'package:flutter/material.dart';
import 'package:AnimeTwistFlut/pages/homepage/HomePage.dart';
import 'package:flutter_riverpod/all.dart';

class ResetToWatchSetting extends StatefulWidget {
  const ResetToWatchSetting({Key key}) : super(key: key);

  @override
  _ResetToWatchSettingState createState() => _ResetToWatchSettingState();
}

class _ResetToWatchSettingState extends State<ResetToWatchSetting> {
  void showConfirmationSnackbar() {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("To watch list cleared!"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.read(toWatchProvider);
    return ListTile(
      title: Text("Reset To Watch list"),
      subtitle: Text("Clear to watch animes"),
      trailing: IconButton(
        icon: Icon(Icons.restore),
        onPressed: provider.hasData()
            ? () => setState(() {
                  provider.clearData();
                  showConfirmationSnackbar();
                })
            : null,
      ),
    );
  }
}
