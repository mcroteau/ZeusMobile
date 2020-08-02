import 'package:flutter/material.dart';
import 'package:zeus/base.dart';
import 'package:zeus/components/searchbox.dart';
import 'package:zeus/components/zeus_highlight.dart';
import 'components/search_results_future_builder.dart';


class Search extends StatefulWidget{
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends BaseState<Search>{


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Search class");
    return Scaffold(
      body: new Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: new SearchResultsFutureBuilder(),
          ),
          Positioned(
            bottom:0,
            left:0,
            right: 0,
            child: ZeusHighlight(),
          ),
        ],
      ),
    );
  }

}