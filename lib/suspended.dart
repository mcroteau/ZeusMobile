
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/base.dart';
import 'package:http/http.dart' as http;
import 'package:zeus/common/c.dart';
import 'package:zeus/services/navigation_service.dart';
import 'dart:convert';

import 'components/searchbox.dart';

class Suspended extends StatefulWidget{
  _SuspendedState createState() => _SuspendedState();
}

class _SuspendedState extends BaseState<Suspended>{

  var suspendedMessage = "This account has been suspended due to activity that is either deemed inappropriate or abusive. You will have to wait 24 hours before someone unlocks your account.";
  NavigationService navigationService;


  @override
  void initState(){
    super.initState();
    setState(() {});
    navigationService = Modular.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body:Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(30),
                margin: EdgeInsets.fromLTRB(30, 67, 30, 0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black87)
                ),
                child : Text(suspendedMessage, style: TextStyle(fontSize: 23, fontWeight: FontWeight.w300))
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 31, 0, 0),
              child: MaterialButton(
                child: Text("Lets go home...", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400)),
                onPressed: navigateToZero,
              )
            )
          ],
        )
    );
  }

  void navigateToZero(){
    navigationService.navigateTo('/');
  }

}