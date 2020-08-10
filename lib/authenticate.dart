import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:zeus/assets/zeus_icons.dart';
import 'package:zeus/base.dart';
import 'dart:convert';
import 'package:zeus/common/c.dart';
import 'package:zeus/posts.dart';
import 'package:zeus/register.dart';
import 'package:zeus/services/navigation_service.dart';
import 'package:zeus/suspended.dart';


class Authenticate extends StatefulWidget{
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends BaseState<Authenticate>{

  TextEditingController emailController;
  TextEditingController passwordController;

  NavigationService navigationService;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    this.emailController = new TextEditingController();
    this.passwordController = new TextEditingController();
    this.navigationService = Modular.get<NavigationService>();

    return new Scaffold(
        resizeToAvoidBottomInset: false,
        body: Flex (
           children: <Widget>[
//             Container(
//               padding: EdgeInsets.fromLTRB(10, 72, 53, 0),
//               alignment: Alignment.center,
//               child: Icon(
//                       Zeus.icon,
//                       size: 19.0,
//                       color: Colors.yellowAccent,
//                     ),
//             ),
             Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(53, 92, 3, 0),
                  child: Icon(Zeus.icon, size: 19, color: Colors.black),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 92, 53, 0),
                  child: Text("Signin", style: TextStyle( fontSize: 29, fontWeight: FontWeight.w900, color: Colors.black))
                  ),
                ]
             ),
             Container(
               padding: EdgeInsets.fromLTRB(30, 47, 72, 0),
                child: TextField(
                  decoration: InputDecoration(hintText: "Email address", hintStyle: TextStyle(color: Colors.black87)),
                  controller: emailController,
                  cursorColor: Colors.white,
                  style: TextStyle(color:Colors.white, fontSize: 21, fontWeight: FontWeight.w200),
                ),
             ),
             Container(
                 padding: EdgeInsets.fromLTRB(30, 10, 72, 0),
                child: TextField(
                  decoration: InputDecoration(hintText: "Password", hintStyle: TextStyle(color: Colors.black87)),
                  controller: passwordController,
                  obscureText: true,
                  style: TextStyle(color:Colors.white, fontSize: 21, fontWeight: FontWeight.w200),
               )
             ),
             Container(
              padding: EdgeInsets.fromLTRB(30, 50, 0, 0),
              child: RaisedButton(
                onPressed: () =>  _signin(),
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                color: Colors.yellowAccent,
                child: new Text("Signin!", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.black)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0),
                ),
              ),
            ),
//             Container(
//               padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
//               child: RaisedButton(
//                 onPressed: () => {
//                   _signinAdmin()
//                 },
//                 child: new Text("Admin!", style: TextStyle(color: Colors.white)),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
//               child: RaisedButton(
//                 onPressed: () => {
//                   _signinGuest()
//                 },
//                 child: new Text("Guest!", style: TextStyle(color: Colors.white)),
//               ),
//             ),
            Container(
                padding: EdgeInsets.fromLTRB(30, 50, 0, 0),
                child: GestureDetector(
                  child: Text("Signup Account!", style: TextStyle(color: Colors.blue)),
                  onTap: () => {
                    _navigateRegister()
                  },
                )
              )
          ],
        direction: Axis.vertical,
        ),
      backgroundColor: Colors.white,
    );
  }

  Future _signin() async{
    try {

      if(emailController.text == "" && passwordController.text == ""){
        super.showGlobalDialog("Please enter you creds!", null);
        return false;
      }

      http.Response resp = await http.post(
          C.API_URI + "authenticate_mobile",
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "username": emailController.text,
            "password": passwordController.text
          }));

      print(resp.toString());
      var session = "";
      resp.headers.forEach((key, value) {
        if(key == "set-cookie")session = value.split(";")[0];
      });
      print(resp.body.toString());
      print("session: $session");

      GetStorage().write(C.SESSION, session);

      dynamic account = jsonDecode(resp.body.toString());

      if(account['profile']['disabled']){
        navigationService.navigateTo('/suspended');
      }else{
          navigationService.navigateTo('/posts');
      }
    }catch(e){
      print("error : $e");
      navigationService.navigateTo('/authenticate');
    }
  }

  Future _signinAdmin() async{
    try {

      http.Response resp = await http.post(
          C.API_URI + "authenticate_mobile",
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "username": "croteau.mike+admin@gmail.com",
            "password": "password"
          }));

      print(resp.toString());
      var session = "";
      resp.headers.forEach((key, value) {
        if(key == "set-cookie")session = value.split(";")[0];
      });
      print(resp.body.toString());
      print("session: $session");

      GetStorage().write(C.SESSION, session);

      dynamic account = jsonDecode(resp.body.toString());

      if(account['profile']['disabled']){
        navigationService.navigateTo('/suspended');
      }else{
        navigationService.navigateTo('/posts');
      }
    }catch(e){
      print("error : $e");
      navigationService.navigateTo('/authenticate');
    }
  }

  Future _signinGuest() async{
    try {

      http.Response resp = await http.post(
          C.API_URI + "authenticate_mobile",
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "username": "mjackson.guest@outlook.com",
            "password": "guest123"
          }));

      print(resp.toString());
      var session = "";
      resp.headers.forEach((key, value) {
        if(key == "set-cookie")session = value.split(";")[0];
      });
      print(resp.body.toString());
      print("session: $session");

      GetStorage().write(C.SESSION, session);

      dynamic account = jsonDecode(resp.body.toString());

      if(account['profile']['disabled']){
        navigationService.navigateTo('/suspended');
      }else{
        navigationService.navigateTo('/posts');
      }
    }catch(e){
      print("error : $e");
      navigationService.navigateTo('/authenticate');
    }
  }

  Future _setProfileId(id) async{
    await GetStorage().write(C.ID, id);
  }

  void _navigateRegister() {
    navigationService.navigateTo('/register');
  }
}

