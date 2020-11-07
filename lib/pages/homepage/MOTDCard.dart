// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:anime_twist_flut/utils/GetUtils.dart';
import 'package:supercharged/supercharged.dart';

// Project imports:
import '../../services/twist_service/TwistApiService.dart';

class MOTDCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MOTDCardState();
  }
}

class _MOTDCardState extends State<MOTDCard> {
  Future<List<String>> _dataInit;
  bool shouldShow = true;

  @override
  void initState() {
    TwistApiService twistApiService = Get.find();
    _dataInit = twistApiService.getMOTD();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _dataInit,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done)
          return AnimatedSwitcher(
            duration: 500.milliseconds,
            child: shouldShow
                ? Padding(
                    padding: EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                      bottom: 15.0,
                    ),
                    child: Card(
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                                top: 15.0,
                                bottom: 10.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    snapshot.data[0],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        shouldShow = false;
                                      });
                                    },
                                    child: Icon(
                                      Icons.close_rounded,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: 20.0,
                                left: 15.0,
                                right: 15.0,
                              ),
                              child: Text(
                                snapshot.data[1],
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
          );
        return Padding(
          padding: EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            bottom: 15.0,
          ),
          child: Card(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(
                  30.0,
                ),
                child: Transform.scale(
                  scale: 0.6,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
