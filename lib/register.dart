import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
             Container(
              padding: EdgeInsets.fromLTRB(30, 50, 0, 0),
              child: RaisedButton(
                onPressed: () => {
                  _register()
                },
                color: Colors.lightBlue,
                child: new Text("Register", style: TextStyle(color: Colors.white)),
              ),
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
}
