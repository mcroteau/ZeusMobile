import 'package:flutter/material.dart';

class C {

  static const Q = "q";
  static const ID = "id";
  static const POST_ID = "post_id";
  static const SESSION = "session";

  static const GO = TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white);
  static const ZEUS = TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 182, 255, 1.0));
  static const TINY = TextStyle(fontSize: 12, fontWeight: FontWeight.w200, color: Color.fromRGBO(0, 0, 0, 1.0));
  static const ACTION = TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Color.fromRGBO(0, 182, 255,1.0));
  static const COUNT = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, 1.0));
  static const SEARCH = TextStyle(fontSize: 23, fontWeight: FontWeight.w900, color: Color.fromRGBO(255, 255, 255, 1.0));
  static const BLUE_BUTTON = TextStyle( fontSize: 17, fontWeight: FontWeight.w200, color: Color.fromRGBO(255, 255, 255, 1.0));

  static const H1 = TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 182, 255, 1.0));

  static const String FirstItem = "Latest Posts";
  static const String SecondItem = "My Profile";
  static const String ThirdItem = "My Invites";
  static const String FourthItem = "Logout";

  static const List<String> choices = <String>[
    FirstItem,
    SecondItem,
    ThirdItem,
    FourthItem,
  ];

//  static const API_URI = "http://zeus.social/b/";
//  static const API_URI = "http://192.168.1.20:8080/b/";
  static const API_URI = "http://192.168.1.76:8080/b/";
//  static const API_URI = "http://192.168.227.12:8080/b/";
}