import 'package:anime_twist_flut/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:video_player_header/video_player_header.dart';
import 'package:supercharged/supercharged.dart';

class DoubleTapLayer extends StatelessWidget {
  final VideoPlayerController videoPlayerController;
  final Function toggleUI;
  final bool isUiVisible;

  const DoubleTapLayer(
      {Key key,
      @required this.videoPlayerController,
      @required this.toggleUI,
      @required this.isUiVisible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.transparent,
      child: Consumer(
        builder: (context, watch, child) {
          var prov = watch(doubleTapDurationProvider);
          int skipDuration = prov.value;
          return Row(
            children: [
              Container(
                color: Colors.transparent,
                height: double.infinity,
                width: width * 0.5,
                child: InkWell(
                  onDoubleTap: () async {
                    videoPlayerController.seekTo(
                        await (videoPlayerController.position) -
                            skipDuration.seconds);
                    toggleUI();
                  },
                  onTap: !isUiVisible
                      ? () {
                          toggleUI();
                        }
                      : null,
                ),
              ),
              Container(
                color: Colors.transparent,
                height: double.infinity,
                width: width * 0.5,
                child: InkWell(
                  onDoubleTap: () async {
                    videoPlayerController.seekTo(
                        await (videoPlayerController.position) +
                            skipDuration.seconds);
                    toggleUI();
                  },
                  onTap: !isUiVisible
                      ? () {
                          toggleUI();
                        }
                      : null,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
