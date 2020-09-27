import 'package:flutter/material.dart';
import 'package:video_player_header/video_player_header.dart';
import 'package:supercharged/supercharged.dart';
import 'package:inkwell_splash/inkwell_splash.dart';

class DoubleTapLayer extends StatelessWidget {
  final VideoPlayerController videoPlayerController;
  final Function toggleUI;

  const DoubleTapLayer(
      {Key key, @required this.videoPlayerController, @required this.toggleUI})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.transparent,
      child: Row(
        children: [
          Container(
            color: Colors.transparent,
            height: double.infinity,
            width: width * 0.5,
            child: InkWellSplash(
              doubleTapTime: 500.milliseconds,
              onDoubleTap: () async {
                videoPlayerController.seekTo(
                    await (videoPlayerController.position) - 10.seconds);
                toggleUI();
              },
              onTap: () {
                toggleUI();
              },
            ),
          ),
          Container(
            color: Colors.transparent,
            height: double.infinity,
            width: width * 0.5,
            child: InkWellSplash(
              doubleTapTime: 500.milliseconds,
              onDoubleTap: () async {
                videoPlayerController.seekTo(
                    await (videoPlayerController.position) + 10.seconds);
                toggleUI();
              },
              onTap: () {
                toggleUI();
              },
            ),
          ),
        ],
      ),
    );
  }
}
