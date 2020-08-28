// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:auto_orientation/auto_orientation.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_android_pip/flutter_android_pip.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';
import 'package:video_player_header/video_player_header.dart';

// Project imports:
import '../../models/EpisodeModel.dart';
import '../../models/KitsuModel.dart';
import '../../models/TwistModel.dart';
import '../../providers/EpisodesWatchedProvider.dart';
import '../../providers/LastWatchedProvider.dart';
import '../../secrets.dart';
import '../../utils/TimeUtils.dart';
import '../../utils/watch_page/CryptoUtils.dart';

class WatchPage extends StatefulWidget {
  final EpisodeModel episodeModel;
  final List<EpisodeModel> episodes;
  final bool isFromPrevEpisode;
  final EpisodesWatchedProvider episodesWatchedProvider;

  final TwistModel twistModel = Get.find();
  final KitsuModel kitsuModel = Get.find();

  WatchPage({
    @required this.episodeModel,
    @required this.episodes,
    this.isFromPrevEpisode = false,
    @required this.episodesWatchedProvider,
  });

  @override
  _WatchPageState createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> with WidgetsBindingObserver {
  VideoPlayerController _controller;
  String _duration;
  bool isUIvisible = false;
  bool isWaiting = false;
  double currentPosition;
  String currentPositionStr;
  bool isPictureInPicture = false;
  bool isTouchingSlider = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      switch (state) {
        case AppLifecycleState.paused:
        case AppLifecycleState.detached:
        case AppLifecycleState.inactive:
          break;
        case AppLifecycleState.resumed:
          isPictureInPicture = false;
          break;
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);

    WidgetsBinding.instance.addObserver(this);

    var headers = {
      'Referer':
          'https://twist.moe/a/${widget.twistModel.slug}/${widget.episodeModel.number}'
    };

    String sourceSuffix =
        CryptoUtils.decryptAESCryptoJS(widget.episodeModel.source, key);

    String vidUrl;
    if (sourceSuffix.startsWith('https')) {
      vidUrl = Uri.parse(sourceSuffix).toString();
    } else {
      vidUrl =
          Uri.parse("https://twistcdn.bunny.sh/" + sourceSuffix).toString();
    }

    _controller = VideoPlayerController.network(vidUrl, headers: headers)
      ..initialize().then((_) {
        setState(() {
          play();
          _duration = TimeUtils.secondsToHumanReadable(
              _controller.value.duration.inSeconds);
        });
        toggleUI();
      });

    _controller.addListener(() {
      setState(() {
        currentPosition = _controller.value.position.inSeconds.toDouble();
        currentPositionStr = TimeUtils.secondsToHumanReadable(
            _controller.value.position.inSeconds);
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    AutoOrientation.fullAutoMode();
    WidgetsBinding.instance.removeObserver(this);
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

  void hideUIAfterWait() async {
    if (!isWaiting && isUIvisible) {
      isWaiting = true;
      Timer(3.seconds, () {
        if (!isTouchingSlider)
          setState(() {
            isUIvisible = false;
          });
        isWaiting = false;
      });
    }
  }

  void toggleUI() async {
    setState(() {
      SystemChrome.setEnabledSystemUIOverlays([]);
      isUIvisible = !isUIvisible;
    });
    hideUIAfterWait();
  }

  void rotate() {
    setState(() {
      if (MediaQuery.of(context).orientation == Orientation.portrait) {
        AutoOrientation.landscapeAutoMode();
      } else {
        AutoOrientation.portraitAutoMode();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double containerHeight =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height * 0.05
            : MediaQuery.of(context).size.height * 0.1;

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
                      opacity: _controller.value.isBuffering ? 1.0 : 0.0,
                      child: Center(
                        child: Transform.scale(
                          scale: 0.5,
                          child: CircularProgressIndicator(),
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
                            IgnorePointer(
                              ignoring: !isUIvisible,
                              child: Visibility(
                                visible: !isPictureInPicture,
                                child: Container(
                                  height: containerHeight,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Colors.transparent,
                                        Colors.black38,
                                        Colors.black87,
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.navigate_before,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  right: 20.0,
                                                ),
                                                child: AutoSizeText(
                                                  widget.twistModel.title,
                                                  maxLines: 2,
                                                  minFontSize: 5.0,
                                                  maxFontSize: 25.0,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              right: 5.0,
                                            ),
                                            child: GestureDetector(
                                              child: Icon(
                                                Icons
                                                    .picture_in_picture_rounded,
                                              ),
                                              onTap: () {
                                                print(isPictureInPicture
                                                    .toString());
                                                setState(() {
                                                  isPictureInPicture = true;
                                                  FlutterAndroidPip
                                                      .enterPictureInPictureMode;
                                                });
                                                print(isPictureInPicture
                                                    .toString());
                                              },
                                            ),
                                          ),
                                          ChangeNotifierProvider<
                                              EpisodesWatchedProvider>.value(
                                            value:
                                                widget.episodesWatchedProvider,
                                            child: Consumer<
                                                EpisodesWatchedProvider>(
                                              builder: (context, prov, child) =>
                                                  Checkbox(
                                                value: prov.isWatched(
                                                  widget.episodeModel.number,
                                                ),
                                                checkColor: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                onChanged: (val) {
                                                  setState(() {
                                                    prov.toggleWatched(
                                                      widget
                                                          .episodeModel.number,
                                                    );
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              right: 15.0,
                                            ),
                                            child: AutoSizeText(
                                              "S" +
                                                  widget.twistModel.season
                                                      .toString() +
                                                  " | E" +
                                                  widget.episodeModel.number
                                                      .toString(),
                                              maxLines: 1,
                                              minFontSize: 5.0,
                                              maxFontSize: 25.0,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            IgnorePointer(
                              ignoring: !isUIvisible,
                              child: Visibility(
                                visible: !isPictureInPicture,
                                child: Container(
                                  height: containerHeight,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Colors.transparent,
                                        Colors.black38,
                                        Colors.black87,
                                      ],
                                      end: Alignment.bottomCenter,
                                      begin: Alignment.topCenter,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 10.0,
                                        ),
                                        child: Container(
                                          width: 30.0,
                                          child: IconButton(
                                            icon: Icon(
                                              _controller.value.isPlaying
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                            ),
                                            onPressed: () {
                                              togglePlay();
                                            },
                                            iconSize: 22.5,
                                          ),
                                        ),
                                      ),
                                      ChangeNotifierProvider.value(
                                        value: LastWatchedProvider.provider,
                                        builder: (context, child) => IconButton(
                                          icon: Icon(
                                            Icons.skip_next_outlined,
                                          ),
                                          iconSize: 22.5,
                                          onPressed: widget.episodes.last ==
                                                  widget.episodeModel
                                              ? null
                                              : () {
                                                  Navigator.pop(context);
                                                  Provider.of<LastWatchedProvider>(
                                                          context,
                                                          listen: false)
                                                      .setData(
                                                    episodeModel: widget
                                                        .episodes
                                                        .elementAt(widget
                                                                .episodes
                                                                .indexOf(widget
                                                                    .episodeModel) +
                                                            1),
                                                    twistModel:
                                                        widget.twistModel,
                                                    kitsuModel:
                                                        widget.kitsuModel,
                                                  );
                                                  Navigator.push(
                                                    context,
                                                    PageRouteBuilder(
                                                      transitionDuration:
                                                          0.seconds,
                                                      pageBuilder: (context,
                                                              anim, anime2) =>
                                                          WatchPage(
                                                        episodeModel: widget
                                                            .episodes
                                                            .elementAt(widget
                                                                    .episodes
                                                                    .indexOf(widget
                                                                        .episodeModel) +
                                                                1),
                                                        episodes:
                                                            widget.episodes,
                                                        isFromPrevEpisode: true,
                                                        episodesWatchedProvider:
                                                            widget
                                                                .episodesWatchedProvider,
                                                      ),
                                                    ),
                                                  );
                                                },
                                        ),
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
                                          max: _controller
                                              .value.duration.inSeconds
                                              .toDouble(),
                                          label:
                                              TimeUtils.secondsToHumanReadable(
                                                  _controller.value.position
                                                      .inSeconds),
                                          divisions: _controller
                                              .value.duration.inSeconds,
                                          onChanged: (pos) {
                                            setState(
                                              () {
                                                _controller.seekTo(pos.seconds);
                                              },
                                            );
                                          },
                                          onChangeStart: (val) => setState(
                                              () => isTouchingSlider = true),
                                          onChangeEnd: (val) => setState(() {
                                            isTouchingSlider = false;
                                            hideUIAfterWait();
                                          }),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 5.0,
                                        ),
                                        child: Text(_duration),
                                      ),
                                      GestureDetector(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            bottom: 3.0,
                                            right: 15.0,
                                            left: 10.0,
                                          ),
                                          child: Icon(
                                            Icons.screen_rotation_rounded,
                                            size: 19.0,
                                          ),
                                        ),
                                        onTap: () {
                                          rotate();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Builder(
                        builder: (context) {
                          SystemChrome.setEnabledSystemUIOverlays([]);
                          return CircularProgressIndicator();
                        },
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      widget.isFromPrevEpisode
                          ? Text("Loading Next Episode")
                          : Text("Loading Episode"),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
