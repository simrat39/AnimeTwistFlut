// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../utils/DonationUtils.dart';

class DonationCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DonationCardState();
  }
}

class _DonationCardState extends State<DonationCard> {
  Future<List<int>> _dataInit;

  @override
  void initState() {
    _dataInit = DonationUtils.getDonations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _dataInit,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done)
          return Card(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Donations",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          snapshot.data[0].toString() +
                              " / " +
                              snapshot.data[1].toString(),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
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
                    child: LinearProgressIndicator(
                      value: snapshot.data[0] / snapshot.data[1],
                    ),
                  ),
                ],
              ),
            ),
          );
        return Card(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(
                15.0,
              ),
              child: Transform.scale(
                scale: 0.5,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      },
    );
  }
}
