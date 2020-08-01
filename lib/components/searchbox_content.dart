import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zeus/common/c.dart';
import 'package:zeus/services/navigation_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zeus/assets/zeus_icons.dart';

class SearchBoxContent extends StatelessWidget{

  var id;
  String session;

  TextEditingController controller;
  NavigationService navigationService;

  SearchBoxContent(){
    this.controller = new TextEditingController();
    this.navigationService = Modular.get<NavigationService>();
    this.session = GetStorage().read(C.SESSION);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Stack(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(15, 4, 5, 0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: InputBorder.none,
                  ),
                  controller: controller,
                  onSubmitted: (value){
                    _search(context, controller).then((data){
                      navigationService.navigateTo('/search');
                    });
                  },
                )
            ),
            Align(
              child: new Container(
                child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget> [
                      new Container(
                        width:107,
                        height: 50,
                        padding: EdgeInsets.fromLTRB(5, 2, 5, 0),
                        decoration: new BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight:Radius.circular(10)),
                        ),
                        child: Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: PopupMenuButton<String>(
                                  icon: Icon(Icons.arrow_drop_down_circle, color: Colors.black),
                                  onSelected: choiceAction,
                                  itemBuilder: (BuildContext context) {
                                    return C.choices.map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                              Container(
                                height:50,
                                width:1,
                                decoration: new BoxDecoration(
                                    color: Colors.yellow
                                ),
                              ),
                              Container(
                                height:50,
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: IconButton(
                                  icon: Icon(Zeus.icon, size: 17, color: Colors.black),
//                                  Text("∑˚", style: C.GO),
                                  onPressed: () =>
                                      navigationService.navigateTo('/posts'),
                                ),
                                decoration: new BoxDecoration(
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight:Radius.circular(10)),
                                ),
                              )
                            ]
                        ),
                      ),
                    ]
                ),
              ),
              alignment: Alignment.centerRight,
            ),
            FutureBuilder(
                future: _fetch(),
                builder: (context, snapshot) {
                  if(snapshot.hasData)
                    this.id = snapshot.data['id'];
                  return Text("");
                }
            )
          ],
        ),
      ),
      elevation: 10,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
//        color: Color.fromRGBO(243, 243, 247, 1),
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
    );
  }

  Future setProfileId() async{
    GetStorage().write(C.ID, id);
  }

  Future<dynamic> _search(BuildContext context, TextEditingController controller) async {
    print("search " + controller.text);
    GetStorage().write(C.Q, controller.text);
  }

  Future<dynamic> _fetch() async {

    http.Response postResponse = await http.get(
        C.API_URI + "account/info",
        headers : {
          "content-type": "application/json",
          "accept": "application/json",
          "cookie" : this.session
        }
    );

    var info = jsonDecode(postResponse.body.toString());
    return info;
  }

  void choiceAction(String choice) {
    if (choice == C.FirstItem) {
      navigationService.navigateTo('/posts');
    } else if (choice == C.SecondItem) {
      setProfileId().then((data){
        navigationService.navigateTo('/profile');
      });
    } else if (choice == C.ThirdItem) {
      navigationService.navigateTo('/invitations');
    } else if (choice == C.FourthItem) {
      _logout().then((data){
        navigationService.navigateTo('/');
      });
    }
  }

  Future _logout() async{
    print("logout");

    http.Response postResponse = await http.get(
        C.API_URI + "logout",
        headers : {
          "content-type": "application/json",
          "accept": "application/json",
          "cookie" : this.session
        }
    );
  }

}