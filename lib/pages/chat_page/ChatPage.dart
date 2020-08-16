// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:web_socket_channel/io.dart';

// Project imports:
import '../../models/chat/MessageModel.dart';

class ChatPage extends StatefulWidget {
  static List<MessageModel> messages = [];

  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  IOWebSocketChannel _channel;
  ScrollController _controller;

  void connect() async {
    _channel = IOWebSocketChannel.connect("wss://ws.twist.moe/");
  }

  @override
  void initState() {
    connect();
    WidgetsBinding.instance.addObserver(this);
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _channel.sink.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      switch (state) {
        case AppLifecycleState.paused:
        case AppLifecycleState.detached:
        case AppLifecycleState.inactive:
          _channel.sink.close();
          break;
        case AppLifecycleState.resumed:
          connect();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "chat.",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Theme.of(context).textTheme.headline6.color,
                ),
              ),
              TextSpan(
                text: "moe",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_downward,
            ),
            onPressed: () {
              _controller.animateTo(
                _controller.position.maxScrollExtent,
                duration: Duration(
                  milliseconds: _controller.offset != 0
                      ? (_controller.position.maxScrollExtent -
                              _controller.offset) ~/
                          5
                      : _controller.position.maxScrollExtent ~/ 5,
                ),
                curve: Curves.ease,
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _channel.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var jsonData = jsonDecode(snapshot.data);
            if (jsonData["type"] == "msg") {
              var message = MessageModel.fromJson(jsonData);
              ChatPage.messages.add(message);
              if (_controller.hasClients) {
                if (_controller.position.pixels ==
                    _controller.position.maxScrollExtent)
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) {
                      _controller.jumpTo(_controller.position.maxScrollExtent);
                    },
                  );
              }
            }
          }
          return Scrollbar(
            isAlwaysShown: true,
            controller: _controller,
            child: ListView.builder(
              controller: _controller,
              itemCount: ChatPage.messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      ChatPage.messages.elementAt(index).userModel.username),
                  subtitle: SelectableText(
                      ChatPage.messages.elementAt(index).message),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
