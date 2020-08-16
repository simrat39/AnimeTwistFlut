// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:supercharged/supercharged.dart';

class BitcoinDonationSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BitcoinDonationSheetState();
  }
}

class _BitcoinDonationSheetState extends State<BitcoinDonationSheet> {
  final List<String> topTexts = [
    "Send your generous donation to the address below. Thanks!",
    "Copied!"
  ];

  final String address = '1ATvQNxFnyVBa4Pd5njdvjTXcECgptzcZo';

  bool isCopied = false;

  void onCopy() {
    setState(() {
      isCopied = true;
    });
    Timer(2.seconds, () {
      setState(() {
        isCopied = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(
        15.0,
      ),
      height: height * 0.6,
      child: OrientationLayoutBuilder(
        portrait: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.chevronDown,
                  ),
                  iconSize: 15.0,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 10.0,
                    top: 5.0,
                  ),
                  child: AutoSizeText(
                    "Bitcoin",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnimatedSwitcher(
                    duration: 1.seconds,
                    child: isCopied ? Text(topTexts[1]) : Text(topTexts[0]),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8.0),
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(
                            text: address,
                          ),
                        );
                        onCopy();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20.0,
                        ),
                        child: Center(
                          child: Text(address),
                        ),
                      ),
                    ),
                  ),
                  Image.network(
                    'https://twist.moe/public/img/bitcoin-qr.png',
                    fit: BoxFit.cover,
                    width: width * 0.75,
                    height: width * 0.75,
                  ),
                ],
              ),
            ),
          ],
        ),
        landscape: (context) => Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.chevronDown,
                        ),
                        iconSize: 15.0,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: 10.0,
                          top: 5.0,
                        ),
                        child: AutoSizeText(
                          "Bitcoin",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AnimatedSwitcher(
                    duration: 1.seconds,
                    child: isCopied ? Text(topTexts[1]) : Text(topTexts[0]),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 40.0,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8.0),
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(
                            text: "1ATvQNxFnyVBa4Pd5njdvjTXcECgptzcZo",
                          ),
                        );
                        onCopy();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20.0,
                        ),
                        child: Center(
                          child: Text("1ATvQNxFnyVBa4Pd5njdvjTXcECgptzcZo"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Image.network(
              'https://twist.moe/public/img/bitcoin-qr.png',
              fit: BoxFit.cover,
              width: height * 0.5,
              height: height * 0.5,
            ),
          ],
        ),
      ),
    );
  }
}
