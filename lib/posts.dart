import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import 'package:zeus/components/posts_future_builder.dart';
import 'package:zeus/components/searchbox.dart';
import 'package:zeus/components/zeus_header.dart';
import 'package:zeus/components/zeus_highlight.dart';
import 'package:zeus/publish.dart';
import 'package:zeus/base.dart';
import 'package:zeus/services/navigation_service.dart';


class Posts extends StatefulWidget{
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends BaseState<Posts>{

  NavigationService navigationService;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.navigationService = Modular.get<NavigationService>();
    return Scaffold(
      body: new Stack(
        children: <Widget>[
          Container(
            color:Color(0xfffffff),
            child: PostsFutureBuilder(),
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(0)
          ),
          Positioned(
            bottom:0,
            left:0,
            right: 0,
            child: ZeusHighlight(),
          ),
        ],
      ),
      floatingActionButton: Container(
          width: 179,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: RaisedButton(
            onPressed: () => {
                navigationService.navigateTo('/publish')
              },
              focusColor: Colors.pinkAccent,
              elevation: 10.0,
              textColor: Colors.white,
              color: Colors.black,
              child: Row(
                children:<Widget> [
                  Icon(Icons.add),
                  Text("Publish New")
                ]
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
              ),
          ),
        ),
      backgroundColor: Colors.white,
    );
  }
}