// Flutter imports:
import 'package:anime_twist_flut/pages/homepage/donation_card/GenericDonationSheet.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:anime_twist_flut/utils/GetUtils.dart';

// Project imports:
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';
import '../../../utils/homepage/DonationUtils.dart';

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
    TwistApiService twistApiService = Get.find();
    _dataInit = twistApiService.getDonationsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _dataInit,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          int currentAmount, totalAmount;
          if ((snapshot.data as List<int>).length > 0) {
            currentAmount = snapshot.data[0];
            totalAmount = snapshot.data[1];
          }
          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(8.0),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text("Patreon"),
                              onTap: () {
                                DonationUtils.donatePatreon();
                              },
                            ),
                            ListTile(
                              title: Text("Bitcoin"),
                              onTap: () {
                                showModalBottomSheet<dynamic>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => GenericDonationSheet(
                                    name: "Bitcoin",
                                    address:
                                        '1ATvQNxFnyVBa4Pd5njdvjTXcECgptzcZo',
                                    qrURL:
                                        'https://twist.moe/public/img/bitcoin-qr.png',
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: Text("Ethereum"),
                              onTap: () {
                                showModalBottomSheet<dynamic>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => GenericDonationSheet(
                                    name: "Ethereum",
                                    address:
                                        "0x8337104096a3297a71ee16a9C922a5ff3818DF46",
                                    qrURL:
                                        'https://twist.moe/public/img/ethereum-qr.png',
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 15.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
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
                              // color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            (currentAmount?.toString() ?? "?") +
                                " / " +
                                (totalAmount?.toString() ?? "?"),
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
                        bottom: 10.0,
                      ),
                      child: LinearProgressIndicator(
                        value: (currentAmount ?? 0.0) / (currentAmount ?? 1.0),
                        backgroundColor:
                            Theme.of(context).accentColor.withOpacity(
                                  0.5,
                                ),
                      ),
                    ),
                    Text(
                      "Tap to contribute!",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Theme.of(context)
                            .textTheme
                            .headline6
                            .color
                            .withOpacity(
                              0.7,
                            ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
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
