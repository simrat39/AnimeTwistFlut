// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:supercharged/supercharged.dart';

class EthereumDonationSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EthereumDonationSheetState();
  }
}

class _EthereumDonationSheetState extends State<EthereumDonationSheet> {
  final List<String> topTexts = [
    "Send your generous donation to the address below. Thanks!",
    "Copied!"
  ];

  final String address = "0x8337104096a3297a71ee16a9C922a5ff3818DF46";

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
            Container(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.chevronDown,
                ),
                iconSize: 15.0,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
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
                    'https://twist.moe/public/img/ethereum-qr.png',
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
                  Container(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.chevronDown,
                      ),
                      iconSize: 15.0,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
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
