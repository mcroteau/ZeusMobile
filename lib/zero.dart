import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:zeus/services/navigation_service.dart';
import 'package:zeus/assets/zeus_icons.dart';

import 'common/c.dart';

class Zero extends StatefulWidget{
  @override
  _ZeroState createState() => _ZeroState();
}

class _ZeroState extends State<Zero> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 67, 30, 0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child:
                Ink(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 4.0),
                    color: Colors.yellowAccent,
                    shape: BoxShape.rectangle,
                  ),
                  child: InkWell(
                    //This keeps the splash effect within the circle
                    borderRadius: BorderRadius.circular(10.0), //Something large to ensure a circle
                    onTap: ()=>{},
                    child: Padding(
                      padding:EdgeInsets.all(59.0),
                      child: Icon(
                        Zeus.icon,
                        size: 62.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(30, 100, 30, 20),
                child: Text("Welcome to Zeus")
            ),
            Container(
              child: RaisedButton(
                onPressed: () => navigateSignin(),
                color: Colors.lightBlue,
                child: new Text("Start Sharing", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }


  void navigateSignin(){
    print('navigate authenticate');
    var navigationService = Modular.get<NavigationService>();
    navigationService.navigateTo('/authenticate');
  }
}