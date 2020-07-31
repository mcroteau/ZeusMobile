
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/assets/zeus_icons.dart';
import 'package:zeus/common/c.dart';
import 'package:zeus/services/navigation_service.dart';

class PostsHeader extends StatelessWidget{

  var id;

  TextEditingController controller;
  NavigationService navigationService;

  PostsHeader(){
    this.controller = new TextEditingController();
    this.navigationService = Modular.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * .8;
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
                    navigationService.navigateTo('/search');
                  });
                },
              )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
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
                )
                ]
                ),
                Align(
                    child:Container(
                      color: Colors.yellowAccent,
                      child: GestureDetector(
                          child: Icon(Zeus.icon, size: 23),
                          onTap: navigatePosts,
                        ),
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.fromLTRB(4, 30, 4, 0),
                      )
                  ),

              ]
            ),
          FutureBuilder(
              future: _fetch(),
              builder: (context, snapshot) {
                if(snapshot.hasData)
                  this.id = snapshot.data['id'];
                return Text("");
              }
          )
      ]
    );
  }

  Future setProfileId() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(C.ID, id.toString());
  }

  Future<dynamic> _search(BuildContext context, TextEditingController controller) async {
    print("search " + controller.text);
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(C.Q, controller.text);
  }

  Future<dynamic> _fetch() async {
    final prefs = await SharedPreferences.getInstance();
    final session = prefs.get(C.SESSION);

    http.Response postResponse = await http.get(
        C.API_URI + "account/info",
        headers : {
          "content-type": "application/json",
          "accept": "application/json",
          "cookie" : session
        }
    );

    var info = jsonDecode(postResponse.body.toString());
    return info;
  }

  void choiceAction(String choice) {

    if (choice == C.FirstItem) {
      navigationService.navigateTo('/posts');
    } else if (choice == C.SecondItem) {
      setProfileId().then((data){
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
    navigationService.navigateTo('/posts');
  }

  Future _logout() async{
    print("logout");
    final prefs = await SharedPreferences.getInstance();
    final session = prefs.get(C.SESSION);

    http.Response postResponse = await http.get(
        C.API_URI + "logout",
        headers : {
          "content-type": "application/json",
          "accept": "application/json",
          "cookie" : session
        }
    );
  }
}