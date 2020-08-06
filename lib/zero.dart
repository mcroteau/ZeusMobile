import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:zeus/authenticate.dart';
import 'package:zeus/posts.dart';
//import 'package:zeus/services/navigation_service.dart';
import 'package:zeus/assets/zeus_icons.dart';
import 'package:zeus/services/navigation_service.dart';

import 'common/c.dart';

class Zero extends StatefulWidget{

  @override
  _ZeroState createState() => _ZeroState();
}

class _ZeroState extends State<Zero> {


  String session;
  NavigationService navigationService;

  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    this.navigationService = Modular.get<NavigationService>();
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
                    color: Colors.white,
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
                padding: EdgeInsets.fromLTRB(30, 63, 30, 20),
                child: Text("Welcome to Zeus")
            ),
            Container(
              child: RaisedButton(
                onPressed: () => _navigateAway(),
                color: Colors.yellowAccent,
                child: new Text("Start Sharing!", style: TextStyle(fontSize:17, fontWeight: FontWeight.w700, color: Colors.black)),
                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.0),
                  side: BorderSide(color: Colors.white, width: 3)
                ),
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }


  void _navigateAway(){
    print('navigate authenticate');
    setAuthenticated().then((date) {
      if(session != null) {
        navigationService.navigateTo('/posts');
      }else{
        navigationService.navigateTo('/authenticate');
      }
    });

  }

  Future setAuthenticated() async {
//    final prefs = await SharedPreferences.getInstance();
//    final sesh = prefs.get(C.SESSION);
    final sesh = GetStorage().read(C.SESSION);
    if(session != ""){
       session = sesh;
    }
  }
}