// Flutter imports:
import 'package:anime_twist_flut/pages/homepage/AppbarText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Project imports:
import '../../services/twist_service/TwistApiService.dart';
import '../../utils/search_page/SearchUtils.dart';
import 'SearchListTile.dart';
import 'SearchPageInputBox.dart';

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
      appBar: AppBar(
        title: AppbarText(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
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
                          i < TwistApiService.allTwistModel.length;
                          i++) {
                        var elem = TwistApiService.allTwistModel.elementAt(i);
                        if (SearchUtils.isTextInAnimeModel(
                          text: _textEditingController.text,
                          twistModel: elem,
                        )) {
                          results.add(
                            SearchListTile(
                              twistModel: elem,
                              node: _focusNode,
                            ),
                          );
                        }
                      }
                      if (results.isEmpty)
                        return ListTile(
                          title: Center(
                            child: Text("No results found :("),
                          ),
                        );
                      return Scrollbar(
                        controller: _scrollController,
                        thickness: 4,
                        child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
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
