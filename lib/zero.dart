import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/authenticate.dart';
import 'package:zeus/posts.dart';
//import 'package:zeus/services/navigation_service.dart';
import 'package:zeus/assets/zeus_icons.dart';

import 'common/c.dart';

class Zero extends StatefulWidget{

  @override
  _ZeroState createState() => _ZeroState();
}

class _ZeroState extends State<Zero> {


  String session;
//  NavigationService navigationService;

  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
//    this.navigationService = Modular.get<NavigationService>();
    return new Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 67, 30, 0),
        color: Colors.yellowAccent,
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
                onPressed: () => _navigateAway(),
                color: Colors.white,
                child: new Text("Start Sharing", style: TextStyle(color: Colors.black)),
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
//        navigationService.navigateTo('/posts');
        Get.to(Posts());
      }else{
//        navigationService.navigateTo('/authenticate');
        Get.to(Authenticate());
      }
    });

  }

  Future setAuthenticated() async {
//    final prefs = await SharedPreferences.getInstance();
//    final sesh = prefs.get(C.SESSION);
    final sesh = GetStorage().read(C.ID);
    if(session != ""){
       session = sesh;
    }
  }
}