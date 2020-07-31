import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:zeus/assets/zeus_icons.dart';
import 'package:zeus/base.dart';
import 'dart:convert';
import 'package:zeus/common/c.dart';
import 'package:zeus/model/zeus_data.dart';
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
    this.emailController = new TextEditingController();
    this.passwordController = new TextEditingController();
//    navigationService = Modular.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    print("build authenticate");
    return new Scaffold(
      body: Flex(
           children: <Widget>[
             Container(
               padding: EdgeInsets.fromLTRB(10, 72, 53, 0),
               alignment: Alignment.center,
               child:
               Ink(
                 decoration: BoxDecoration(
                   border: Border.all(color: Colors.white, width: 4.0),
                   color: Colors.yellowAccent,
                   shape: BoxShape.circle,
                 ),
                 child: InkWell(
                   //This keeps the splash effect within the circle
                   borderRadius: BorderRadius.circular(10.0), //Something large to ensure a circle
                   onTap: ()=>{},
                   child: Padding(
                     padding:EdgeInsets.all(19.0),
                     child: Icon(
                       Zeus.icon,
                       size: 19.0,
                       color: Colors.black,
                     ),
                   ),
                 ),
               ),
             ),
             Container(
                 padding: EdgeInsets.fromLTRB(10, 20, 53, 0),
                 child: Text("Signin", style: TextStyle( fontSize: 42))
             ),
             Container(
               padding: EdgeInsets.fromLTRB(10, 20, 72, 0),
                child: TextField(
                  decoration: InputDecoration(hintText: "Email"),
                  controller: emailController,
                ),
             ),
             Container(
                 padding: EdgeInsets.fromLTRB(10, 10, 72, 0),
                child: TextField(
                  decoration: InputDecoration(hintText: "Password"),
                  controller: passwordController,
               )
             ),
             Container(
              padding: EdgeInsets.fromLTRB(30, 50, 0, 0),
              child: RaisedButton(
                onPressed: () => {
                  _signin()
                },
                color: Colors.lightBlue,
                child: new Text("Signin", style: TextStyle(color: Colors.white)),
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(30, 50, 0, 0),
                child: GestureDetector(
                  child: Text("Signup Account!", style: TextStyle(color: Colors.blueAccent)),
                  onTap: () => {
                    _navigateRegister()
                  },
                )
              )
          ],
        direction: Axis.vertical,
        )
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


      dynamic account = jsonDecode(resp.body.toString());

      if(account['profile']['disabled']){
//        navigationService.navigateTo('/suspended');
        Get.to(Suspended());
      }else{
        _setSession(session).then((data){
//          navigationService.navigateTo('/posts');
          Get.to(Posts());
        });
      }
    }catch(e){
      print("error : $e");
//      navigationService.navigateTo('');
      Get.to(Authenticate());
    }
  }

  Future _setSession(session) async {
//    Get.find<ZeusData>().setSession(session);
    GetStorage().write(C.SESSION, session);
  }

  Future _setProfileId(id) async{
//    Get.find<ZeusData>().setId(id);
    GetStorage().write(C.ID, id);
  }

  void _navigateRegister() {
//    navigationService.navigateTo('/register');
    Get.to(Register());
  }
}

