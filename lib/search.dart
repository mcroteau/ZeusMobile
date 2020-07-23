import 'package:flutter/material.dart';
import 'package:zeus/base.dart';
import 'package:zeus/components/searchbox.dart';
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
            child: new SearchResultsFutureBuilder(),
          ),
          SearchBox(false)
        ],
      ),
    );
  }

}