// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:auto_orientation/auto_orientation.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
import '../../utils/watch_page/CryptoUtils.dart';

class WatchPage extends StatefulWidget {
  final EpisodeModel episodeModel;
  final List<EpisodeModel> episodes;
  final TwistModel twistModel;
  final KitsuModel kitsuModel;
  final bool isFromPrevEpisode;
  final EpisodesWatchedProvider episodesWatchedProvider;

  WatchPage({
    @required this.episodeModel,
    @required this.episodes,
    @required this.twistModel,
    @required this.kitsuModel,
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
  double currentPosition;
  String currentPositionStr;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state.index != AppLifecycleState.resumed.index) {
      setState(() {
        pause();
      });
    }
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);

    WidgetsBinding.instance.addObserver(this);

    var headers = {
      'Referer':
          'https://twist.moe/a/${widget.twistModel.slug}/${widget.episodeModel.number}'
    };

    String vidUrl = Uri.parse("https://twistcdn.bunny.sh/" +
            CryptoUtils.decryptAESCryptoJS(widget.episodeModel.source, key))
        .toString();

    _controller = VideoPlayerController.network(vidUrl, headers: headers)
      ..initialize().then((_) {
        setState(() {
          play();
          _duration =
              secondsToHumanReadable(_controller.value.duration.inSeconds);
        });
        toggleUI();
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

  void toggleUI() async {
    setState(() {
      SystemChrome.setEnabledSystemUIOverlays([]);
      isUIvisible = !isUIvisible;
    });
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

  String secondsToHumanReadable(int val) {
    String minutes = (val ~/ 60).toString();
    String seconds = (val % 60).toString();
    if (seconds.length == 1) seconds = "0$seconds";
    if (minutes.length == 1) minutes = "0$minutes";
    return "$minutes:$seconds";
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
                            Container(
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
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.navigate_before,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      AutoSizeText(
                                        widget.twistModel.title,
                                        maxLines: 1,
                                        minFontSize: 5.0,
                                        maxFontSize: 25.0,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      ChangeNotifierProvider<
                                          EpisodesWatchedProvider>.value(
                                        value: widget.episodesWatchedProvider,
                                        child:
                                            Consumer<EpisodesWatchedProvider>(
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
                                                  widget.episodeModel.number,
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
                            IgnorePointer(
                              ignoring: !isUIvisible,
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
                                    GestureDetector(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          right: 5.0,
                                          left: 15.0,
                                        ),
                                        child: Icon(
                                          _controller.value.isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          size: 22.5,
                                        ),
                                      ),
                                      onTap: () {
                                        togglePlay();
                                      },
                                    ),
                                    ChangeNotifierProvider.value(
                                      value: LastWatchedProvider.provider,
                                      builder: (context, child) =>
                                          GestureDetector(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            right: 10.0,
                                            left: 5.0,
                                          ),
                                          child: Icon(
                                            Icons.skip_next_outlined,
                                            size: 22.5,
                                          ),
                                        ),
                                        onTap: widget.episodes.last ==
                                                widget.episodeModel
                                            ? null
                                            : () {
                                                Navigator.pop(context);
                                                Provider.of<LastWatchedProvider>(
                                                        context,
                                                        listen: false)
                                                    .setData(
                                                  episodeModel: widget.episodes
                                                      .elementAt(widget.episodes
                                                              .indexOf(widget
                                                                  .episodeModel) +
                                                          1),
                                                  twistModel: widget.twistModel,
                                                  kitsuModel: widget.kitsuModel,
                                                );
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        WatchPage(
                                                      episodeModel: widget
                                                          .episodes
                                                          .elementAt(widget
                                                                  .episodes
                                                                  .indexOf(widget
                                                                      .episodeModel) +
                                                              1),
                                                      episodes: widget.episodes,
                                                      twistModel:
                                                          widget.twistModel,
                                                      kitsuModel:
                                                          widget.kitsuModel,
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
                                        label: secondsToHumanReadable(
                                            _controller
                                                .value.position.inSeconds),
                                        divisions: _controller
                                            .value.duration.inSeconds,
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
                                          size: 20.0,
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
