import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import '../../utils/TwistUtils.dart';
import '../../utils/SearchUtils.dart';

import 'SearchPageInputBox.dart';
import 'SearchListTile.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _textEditingController;
  ScrollController _scrollController;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: "");
    _scrollController = ScrollController()
      ..addListener(
        () {
          FocusScope.of(context).unfocus();
        },
      );
    _focusNode = FocusNode()
      ..addListener(
        () {
          if (_focusNode.hasFocus) {
            _scrollController.jumpTo(_scrollController.position.pixels);
            FocusScope.of(context).requestFocus(_focusNode);
          }
        },
      );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: SearchPageInputBox(
                  focusNode: _focusNode,
                  controller: _textEditingController,
                  onChanged: (text) {
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 5.0,
                  ),
                  child: Builder(
                    builder: (context) {
                      List<Widget> results = [];
                      for (int i = 0;
                          i < TwistUtils.allTwistModel.length;
                          i++) {
                        var elem = TwistUtils.allTwistModel.elementAt(i);
                        if (SearchUtils.isTextInAnimeModel(
                          text: _textEditingController.text,
                          model: elem,
                        )) {
                          results.add(
                            SearchListTile(
                              animeModel: elem,
                              node: _focusNode,
                            ),
                          );
                        }
                      }
                      return CupertinoScrollbar(
                        child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) => results[index],
                          itemCount: results.length,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
