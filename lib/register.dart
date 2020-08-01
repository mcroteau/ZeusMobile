import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:zeus/assets/zeus_icons.dart';
import 'package:zeus/base.dart';
import 'dart:convert';
import 'package:zeus/common/c.dart';
import 'package:zeus/services/navigation_service.dart';


class Register extends StatefulWidget{
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends BaseState<Register>{

  var eulaMessage = "I agree not to post anything rude or abusive. " +
          "I agree not to be rude to others, \n" +
          "If you agree to these requirements, you may continue.";

  bool agreed = false;

  TextEditingController nameController;
  TextEditingController emailController;
  TextEditingController passwordController;

  NavigationService navigationService;

  @override
  void initState() {
    super.initState();
    this.nameController = new TextEditingController();
    this.emailController = new TextEditingController();
    this.passwordController = new TextEditingController();
    navigationService = Modular.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
          padding: EdgeInsets.fromLTRB(30, 62, 90, 0),
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
                 child: Text("Register", style: TextStyle( fontSize: 42))
             ),
             Container(
               child: TextField(
                 decoration: InputDecoration(hintText: "Name"),
                 controller: nameController,
               ),
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
             Row(
               children: <Widget>[
                 Checkbox(
                   onChanged: (value) => {
                      setState(() {
                        agreed = value;
                      })
                   },
                   value: agreed,

                 ),
                 GestureDetector(
                  child: Text("I Agree to Eula", style: TextStyle(color: Colors.lightBlue)),
                   onTap: () => {
                     _confirmation(eulaMessage)
                   },
                 )
               ],
             ),
             Container(
              padding: EdgeInsets.fromLTRB(30, 50, 0, 0),
              child: RaisedButton(
                onPressed: () => {
                  if(agreed){
                    _register()
                  }else{
                    super.showGlobalDialog("You must agree with the End-User License Agreement.", null)
                  }
                },
                color: Colors.lightBlue,
                child: new Text("Register", style: TextStyle(color: Colors.white)),
              ),
            ),
             Container(
                 padding: EdgeInsets.fromLTRB(30, 30, 0, 50),
                 child: GestureDetector(
                   child: Text("Signin", style: TextStyle(color: Colors.blueAccent)),
                   onTap: () => {
                     _navigateSignin()
                   },
                 )
             )
          ]
        )
      )
    );
  }

  Future _register() async{
    try {

      if(nameController.text == "" &&
          emailController.text == "" &&
          passwordController.text == ""){
        super.showGlobalDialog("Please enter your creds!", null);
        return false;
      }

      print(nameController.text + " : " + emailController.text);

      http.Response response = await http.post(
          C.API_URI + "register_mobile",
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "name": nameController.text,
            "username": emailController.text,
            "password": passwordController.text
          }));

      print(response.toString());
      print(response.body.toString());

      dynamic data = jsonDecode(response.body.toString());
      if(data['error'] != null && data['error']){
        super.showGlobalDialog(data['error'], null);
      }else{
        super.showGlobalDialog("Successfully registered! Have fun!", navigateAuthenticate);
      }

    }catch(e){
      print("error : $e");
      super.showGlobalDialog("Would you contact us, something went wrong on our end. Gracias!", null);
      navigationService.navigateTo('/register');
    }
    return true;
  }

  navigateAuthenticate() {
    navigationService.navigateTo('/authenticate');
  }

  _navigateSignin() {
    navigationService.navigateTo('/authenticate');
  }

  void _confirmation(message){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("End-User License Agreement"),
            content: new Text(message),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Okay!"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }
}
