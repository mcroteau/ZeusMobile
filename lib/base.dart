import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:zeus/common/c.dart';
import 'package:zeus/posts.dart';
import 'package:zeus/authenticate.dart';
import 'package:zeus/profile.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {

  var count = "Zeus";
  int _currentIndex;
  TextEditingController search_controller;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    var future = new Future.delayed(const Duration(milliseconds: 3000));
//    var subscription = future.asStream().listen(poll);
////    subscription.cancel();
    search_controller = new TextEditingController();
    return new Scaffold(
      body: Center( child: Text("Zeus Mobile"))
    );
  }


  void showGlobalDialog(String content, Function funct){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Message"),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Okay!"),
              onPressed: () {
                Navigator.of(context).pop();
                if(funct != null)
                  funct.call();
              },
            ),
          ],
        );
      }
    );
  }

  void showGlobalDialogNoOkay(String content, Function funct){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Message"),
            content: new Text(content),
          );
        }
    );
  }

  void confirmation(message, funct){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Message"),
            content: new Text(message),
            actions: <Widget>[
              new FlatButton(
                  child: new Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
              ),
              new FlatButton(
                child: new Text("Okay!"),
                onPressed: () {
                  Navigator.of(context).pop();
                  if(funct != null)
                    funct.call();
                },
              ),
            ],
          );
        }
    );
  }

  void poll(event) {
    print("polling");
    count = "13";
  }
}