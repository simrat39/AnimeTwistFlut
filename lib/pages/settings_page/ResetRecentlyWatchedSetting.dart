import 'package:flutter/material.dart';
import 'package:AnimeTwistFlut/pages/homepage/HomePage.dart';
import 'package:flutter_riverpod/all.dart';

class ResetRecentlyWatchedSetting extends StatefulWidget {
  const ResetRecentlyWatchedSetting({Key key}) : super(key: key);

  @override
  _ResetRecentlyWatchedSettingState createState() =>
      _ResetRecentlyWatchedSettingState();
}

class _ResetRecentlyWatchedSettingState
    extends State<ResetRecentlyWatchedSetting> {
  void showConfirmationSnackbar() {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Recently watched animes cleared!"),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.read(recentlyWatchedProvider);
    return ListTile(
      title: Text("Reset Recently Watched"),
      subtitle: Text("Clear recently watched animes"),
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
