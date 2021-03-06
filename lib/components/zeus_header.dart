
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:zeus/assets/zeus_icons.dart';
import 'package:zeus/base.dart';
import 'package:zeus/common/c.dart';
import 'package:zeus/services/navigation_service.dart';

class ZeusHeader extends StatefulWidget {
  _ZeusHeaderState createState() => _ZeusHeaderState();
}

class _ZeusHeaderState extends BaseState<ZeusHeader> with AutomaticKeepAliveClientMixin<ZeusHeader>{

  @override
  bool get wantKeepAlive => true;

  var id;
  var timer;
  var session;

  var latestPosts;
  var invitationsCount;

  TextEditingController controller;
  NavigationService navigationService;


  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.session = GetStorage().read(C.SESSION);
    this.controller = new TextEditingController();
    this.navigationService = Modular.get<NavigationService>();
    return FutureBuilder(
      future:_fetchProfileInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return Stack(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.fromLTRB(7, 42, 5, 0),
                    child: TextField(
                      style: TextStyle( fontSize: 24, fontWeight: FontWeight.w300),
                      decoration: InputDecoration(
                        hintText: "Search",
//                  border: InputBorder.none,
                      ),
                      controller: controller,
                      onSubmitted: (value) {
                          print("searching... $value");
                          GetStorage().write(C.Q, controller.text);
                          navigationService.navigateTo('/search');
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
                                elevation: 3,
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
                            Text(invitationsCount != null &&
                                invitationsCount.toString() != "0"
                                ? invitationsCount.toString()
                                : "",)
                          ]
                      ),
                      Align(
                          child: GestureDetector(
                            child: Container(
                                color: Colors.yellowAccent,
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.fromLTRB(0, 10, 4, 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Icon(Zeus.icon, size: 23),
                                    ),
                                  ],
                                )
                            ),
                            onTap: () => navigatePosts(),
                          )
                      ),
                    ]
                ),
              ]
          );
        else
//          return Center(child: CircularProgressIndicator());
          return Text("");
      }
    );
  }

  Future<Map<String, dynamic>> _fetchProfileInfo() async {
    try {
      http.Response resp = await http.get(
          C.API_URI + "account/info",
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            "cookie": this.session
          }
      );

      var data = jsonDecode(resp.body.toString());
      print("set " + data['id'].toString());

      await GetStorage().write(C.PROFILE_ID, data['id'].toString());

      return data;

    }catch(e){
      print("header error $e");
    }
  }

  void choiceAction(String choice) {

//    this.timer.cancel();
    print("header $id");

    if (choice == C.FirstItem) {
      navigationService.navigateTo('/posts');
    } else if (choice == C.SecondItem) {
      _fetchProfileInfo().then((data){
        GetStorage().write(C.ID, data['id']);
        print("navigation my profile : " + GetStorage().read(C.PROFILE_ID));
        navigationService.navigateTo('/profile');
      });
    } else if (choice == C.ThirdItem) {
      navigationService.navigateTo('/invitations');
    } else if (choice == C.FourthItem) {
      _logout().then((data){
        navigationService.navigateTo('/');
      });
    }
  }

  void navigatePosts() {
//    this.timer.cancel();
    navigationService.navigateTo('/posts');
  }

  Future _logout() async{
//    this.timer.cancel();

    http.Response resp = await http.get(
        C.API_URI + "signout",
        headers : {
          "content-type": "application/json",
          "accept": "application/json",
          "cookie" : this.session
        }
    );
    print("logout : " + resp.body.toString());
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