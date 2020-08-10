import 'package:flutter/cupertino.dart';
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
  Future future;
  NavigationService navigationService;

  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    this.navigationService = Modular.get<NavigationService>();
//    this.future = new Future.delayed(const Duration(milliseconds: 3000), navigateAway);
    return new Scaffold(
      body: GestureDetector(
        onTap: () => navigateAway(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(30, 72, 30, 0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Padding(
                      padding:EdgeInsets.all(59.0),
                      child: Icon(
                        Zeus.icon,
                        size: 62.0,
                        color: Colors.black,
                      ),
                    ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(30, 63, 30, 70),
                child: Text("Welcome!", style: TextStyle(color: Colors.black, fontSize: 29, fontWeight: FontWeight.w900))
            ),
            Container(
                padding: EdgeInsets.fromLTRB(30, 23, 30, 70),
                child: Text("Like. Share. Obey!", style: TextStyle(color: Colors.black, fontSize: 19, fontWeight: FontWeight.w300))
            ),
            Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                child: Text("Continue...", textAlign:TextAlign.right, style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w300, decoration: TextDecoration.underline))
            ),
//            Container(
//              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
//              child: RaisedButton(
//                onPressed: () => _navigateAway(),
//                color: Colors.lightBlue,
//                child: new Text("Start Sharing!", style: TextStyle(fontSize:17, fontWeight: FontWeight.w700, color: Colors.white)),
//                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
//                shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(28.0),
//                  side: BorderSide(color: Colors.white, width: 3)
//                ),
//              ),
//            )
          ],
        ),
      ),
      ),
      backgroundColor: Colors.yellowAccent,
    );
  }


  void navigateAway(){
    print('navigate authenticate');
    getSession().then((date) {
      if(session != null) {
        navigationService.navigateTo('/posts');
      }else{
        navigationService.navigateTo('/authenticate');
      }
    });

  }

  Future getSession() async {
    final sesh = await GetStorage().read(C.SESSION);
    if(session != ""){
       session = sesh;
    }
  }
}