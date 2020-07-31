
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/assets/zeus_icons.dart';
import 'package:zeus/base.dart';
import 'package:zeus/common/c.dart';
import 'package:zeus/model/zeus_data.dart';
import 'package:zeus/posts.dart';
import 'package:zeus/profile.dart';
import 'package:zeus/zero.dart';
//import 'package:zeus/services/navigation_service.dart';

class ZeusHeader extends StatefulWidget {
  _ZeusHeaderState createState() => _ZeusHeaderState();
}

class _ZeusHeaderState extends BaseState<ZeusHeader>{

  var id;
  var timer;
  var session;

  var latestPosts;
  var invitationsCount;

  ZeusData zeusData;

  TextEditingController controller;
//  NavigationService navigationService;


  @override
  void initState(){
    super.initState();
    setSession();

  }

  @override
  Widget build(BuildContext context) {
    _fetch();
    this.zeusData = Get.find();
    this.controller = new TextEditingController();
//    this.navigationService = Modular.get<NavigationService>();
//    this.zeusData = Modular.get<ZeusData>();
    return Stack(
        children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(3, 42, 5, 0),
              child: TextField(
                style: TextStyle(fontSize:24, fontWeight: FontWeight.w300),
                decoration: InputDecoration(
                  hintText: "Search",
//                  border: InputBorder.none,
                ),
                controller: controller,
                onSubmitted: (value){
                  _search(context, controller).then((data){
//                    navigationService.navigateTo('/search');
                  });
                },
              )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                      child: PopupMenuButton<String>(
                        icon: Icon(Icons.menu, color: Colors.black12),
                        onSelected: choiceAction,
                        itemBuilder: (BuildContext context) {
                          return C.choices.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    Text(invitationsCount != null && invitationsCount.toString() != "0" ? invitationsCount.toString() : "", )
                  ]
                ),
                Align(
                  child: Container(
                    color: Colors.yellowAccent,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.fromLTRB(0, 10, 4, 0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: GestureDetector(
                            child: Icon(Zeus.icon, size: 23),
                            onTap: navigatePosts,
                          ),
                        ),
                      ],
                    )
                  )
                )
              ]
            ),
      ]
    );
  }

  Future setSession() async{
    final prefs = await SharedPreferences.getInstance();
    this.session = prefs.get(C.SESSION);
  }

  Future setProfileId(id) async{
    this.id = id;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(C.ID, id.toString());
    this.session = prefs.get(C.SESSION);
  }

  Future<dynamic> _search(BuildContext context, TextEditingController controller) async {
    print("search " + controller.text);
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(C.Q, controller.text);
  }

  Future<dynamic> _fetch() async {
    try {
      http.Response postResponse = await http.get(
          C.API_URI + "account/info",
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            "cookie": session
          }
      );

      var data = jsonDecode(postResponse.body.toString());
      print("set " + data['id'].toString());
      zeusData.id = data['id'];
      return data;
    }catch(e){
      print("error $e");
    }
  }

  void choiceAction(String choice) {

//    this.timer.cancel();
    print("header $id");

    if (choice == C.FirstItem) {
//      navigationService.navigateTo('/posts');
      Get.to(Posts());
    } else if (choice == C.SecondItem) {
      print("z: " + zeusData.toString());
//      navigationService.navigateTo('/profile');
      Get.to(Profile());
    } else if (choice == C.ThirdItem) {
//      navigationService.navigateTo('/invitations');
    } else if (choice == C.FourthItem) {
      _logout().then((data){
//        navigationService.navigateTo('/');
          Get.to(Zero());
      });
    }
  }

  void navigatePosts() {
//    this.timer.cancel();
//    navigationService.navigateTo('/posts');
  }

  Future _logout() async{
//    this.timer.cancel();
    final prefs = await SharedPreferences.getInstance();
    final session = prefs.get(C.SESSION);

    http.Response logoutResponse = await http.get(
        C.API_URI + "logout",
        headers : {
          "content-type": "application/json",
          "accept": "application/json",
          "cookie" : session
        }
    );
  }

  String getLatestPosts(latestPosts){
    print("get latest posts" + latestPosts?.length.toString());
    if(latestPosts != null && latestPosts?.length.toString() != "0"){
      return latestPosts.length.toString();
    }else{
      return "";
    }
  }
}