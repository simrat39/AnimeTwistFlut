import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:video_player_header/video_player_header.dart';
import 'package:supercharged/supercharged.dart';

import '../../utils/CryptoUtils.dart';
import '../../secrets.dart';

import '../../models/TwistModel.dart';
import '../../models/EpisodeModel.dart';

class WatchPage extends StatefulWidget {
  final EpisodeModel episodeModel;
  final List<EpisodeModel> episodes;
  final TwistModel twistModel;

  WatchPage({
    this.episodeModel,
    this.episodes,
    this.twistModel,
  });

  @override
  _WatchPageState createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> {
  VideoPlayerController _controller;
  String _duration;
  bool isUIvisible = false;
  double currentPosition;
  String currentPositionStr;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    var headers = {
      'Referer':
          'https://twist.moe/a/${widget.twistModel.slug.slug}/${widget.episodeModel.number}'
    };

    String vidUrl = Uri.parse("https://twistcdn.bunny.sh/" +
            CryptoUtils.decryptAESCryptoJS(widget.episodeModel.source, key))
        .toString();

    _controller = VideoPlayerController.network(vidUrl, headers: headers)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _duration =
              secondsToHumanReadable(_controller.value.duration.inSeconds);
        });
      });

    _controller.addListener(() {
      setState(() {
        currentPosition = _controller.value.position.inSeconds.toDouble();
        currentPositionStr =
            secondsToHumanReadable(_controller.value.position.inSeconds);
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    _controller.dispose();
    super.dispose();
  }

  void play() {
    _controller.play();
  }

  void pause() {
    _controller.pause();
  }

  void togglePlay() {
    setState(() {
      _controller.value.isPlaying ? pause() : play();
    });
  }

  void toggleUI() async {
    setState(() {
      SystemChrome.setEnabledSystemUIOverlays([]);
      isUIvisible = !isUIvisible;
    });
  }

  String secondsToHumanReadable(int val) {
    String minutes = (val ~/ 60).toString();
    String seconds = (val % 60).toString();
    if (seconds.length == 1) seconds = "0$seconds";
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        toggleUI();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: _controller.value.initialized
              ? Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    GestureDetector(
                      onTap: () {
                        toggleUI();
                      },
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(
                            _controller,
                          ),
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      duration: 300.milliseconds,
                      opacity: isUIvisible ? 1.0 : 0.0,
                      child: GestureDetector(
                        onTap: () {
                          if (!(isUIvisible)) toggleUI();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: MediaQuery.of(context).orientation ==
                                      Orientation.portrait
                                  ? MediaQuery.of(context).size.height * 0.075
                                  : MediaQuery.of(context).size.height * 0.125,
                              width: double.infinity,
                              color: Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(0.75),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.navigate_before,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      Text(
                                        widget.twistModel.title +
                                            "\n" +
                                            "Season " +
                                            widget.twistModel.season
                                                .toString() +
                                            " | Episode " +
                                            widget.episodeModel.number
                                                .toString(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 15.0,
                                        ),
                                        child: RaisedButton(
                                          child: Text("Next Ep"),
                                          color: Theme.of(context).accentColor,
                                          colorBrightness: Brightness.light,
                                          onPressed:
                                              widget.episodes.last ==
                                                      widget.episodeModel
                                                  ? null
                                                  : () {
                                                      Navigator.pop(context);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              WatchPage(
                                                            episodeModel: widget
                                                                .episodes
                                                                .elementAt(widget
                                                                        .episodes
                                                                        .indexOf(
                                                                            widget.episodeModel) +
                                                                    1),
                                                            episodes:
                                                                widget.episodes,
                                                            twistModel: widget
                                                                .twistModel,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 15.0,
                                        ),
                                        child: RaisedButton(
                                          color: Theme.of(context).accentColor,
                                          colorBrightness: Brightness.light,
                                          child: Text("Skip Intro"),
                                          onPressed: () {
                                            _controller.seekTo((_controller
                                                        .value
                                                        .position
                                                        .inSeconds +
                                                    85)
                                                .seconds);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).orientation ==
                                      Orientation.portrait
                                  ? MediaQuery.of(context).size.height * 0.075
                                  : MediaQuery.of(context).size.height * 0.125,
                              width: double.infinity,
                              color: Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(0.75),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      _controller.value.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                    ),
                                    onPressed: () {
                                      togglePlay();
                                    },
                                  ),
                                  Text(
                                    currentPositionStr,
                                  ),
                                  Expanded(
                                    child: Slider(
                                      value: _controller
                                          .value.position.inSeconds
                                          .toDouble(),
                                      activeColor:
                                          Theme.of(context).accentColor,
                                      inactiveColor: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.5),
                                      min: 0,
                                      max: _controller.value.duration.inSeconds
                                          .toDouble(),
                                      onChanged: (pos) {
                                        setState(
                                          () {
                                            _controller.seekTo(pos.seconds);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: 15.0,
                                    ),
                                    child: Text(_duration),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     toggleUI();
                    //   },
                    //   child: AnimatedOpacity(
                    //     duration: 300.milliseconds,
                    //     opacity: _controller.value.isBuffering ? 1.0 : 0.0,
                    //     child: Center(
                    //       child: CircularProgressIndicator(),
                    //     ),
                    //   ),
                    // ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
