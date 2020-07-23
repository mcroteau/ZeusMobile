import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:zeus/assets/zeus_icons.dart';
import 'package:zeus/base.dart';
import 'dart:convert';
import 'package:zeus/common/c.dart';
import 'package:zeus/services/navigation_service.dart';


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
    navigationService = Modular.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
          padding: EdgeInsets.fromLTRB(30, 120, 90, 0),
          child: Column(
           children: <Widget>[
             Container(
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
                 padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                 child: Text("Signin", style: TextStyle( fontSize: 42))
             ),
             Container(
                child: TextField(
                  decoration: InputDecoration(hintText: "Email"),
                  controller: emailController,
                ),
             ),
             Container(
                child: TextField(
                  decoration: InputDecoration(hintText: "Password"),
                  controller: passwordController,
                  obscureText: true,
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
          ]
        )
      )
    );
  }

  Future _signin() async{
    try {

      if(emailController.text == "" && passwordController.text == ""){
        super.showGlobalDialog("Please enter you creds!", null);
        return false;
      }

      http.Response response = await http.post(
          C.API_URI + "authenticate_mobile",
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "username": emailController.text,
            "password": passwordController.text
          }));

      print(response.toString());
      var session = "";
      response.headers.forEach((key, value) {
        if(key == "set-cookie")session = value.split(";")[0];
      });
      print(response.body.toString());
      print("session: $session");

      final prefs = await SharedPreferences.getInstance();
      prefs.setString("session", session);

      if(session != null && session != ""){
        navigationService.navigateTo('/posts');
      }
    }catch(e){
      print("error : $e");
      navigationService.navigateTo('/');
    }
  }

  void _navigateRegister() {
    navigationService.navigateTo('/register');
  }
}

