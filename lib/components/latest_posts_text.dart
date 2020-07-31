
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/assets/zeus_icons.dart';
import 'package:zeus/base.dart';
import 'package:zeus/common/c.dart';
import 'package:zeus/services/navigation_service.dart';

class LatestPostsText extends StatefulWidget {

  var latestPosts;
  LatestPostsText(latestPosts){
    this.latestPosts = latestPosts;
  }
  _LatestPostsTextState createState() => _LatestPostsTextState(latestPosts);
}

class _LatestPostsTextState extends BaseState<LatestPostsText> {

  var latestPosts;

  _LatestPostsTextState(latestPosts){
    this.latestPosts = latestPosts;
  }

  @override
  Widget build(BuildContext context){
    return Text(getLatestPosts());
  }

  String getLatestPosts(){
    print("get latest posts" + latestPosts?.length.toString());
    if(latestPosts != null && latestPosts?.length.toString() != "0"){
      return latestPosts.length.toString();
    }else{
      return "";
    }
  }
}
