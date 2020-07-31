import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/components/posts_future_builder.dart';
import 'package:zeus/components/searchbox.dart';
import 'package:zeus/components/zeus_highlight.dart';
import 'package:zeus/publish.dart';
import 'package:zeus/base.dart';
import 'package:zeus/services/navigation_service.dart';


class Posts extends StatefulWidget{
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends BaseState<Posts>{

  @override
  void initState() {
    try{
      super.initState();
    }catch(e){
      print('Unexpected error : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(
        children: <Widget>[
          Container(
            color:Colors.white,
            child: PostsFutureBuilder(),
          ),
//          SearchBox(true),
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => new Publish(), fullscreenDialog: false),
                )
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

//      Container(
//        margin: EdgeInsets.fromLTRB(30, 0, 0, 10),
//        child: new RaisedButton(
//          onPressed: () => {
//              Navigator.pushReplacement(
//                context,
//                MaterialPageRoute(builder: (context) => new Publish(), fullscreenDialog: false),
//              )
//            },
//            elevation: 10.0,
//            textColor: Colors.white,
//            color: Colors.lightBlue,
//            child: Row(
//              children:<Widget> [
//                Icon(Icons.add),
//                Text("Publish New")
//              ]
//            )
//        ),
//      ),
    );
  }
}