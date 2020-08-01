import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:zeus/base.dart';
import 'package:zeus/common/c.dart';
import 'package:zeus/components/zeus_header.dart';
import 'package:zeus/components/searchbox.dart';
import 'package:zeus/services/navigation_service.dart';

class Invitations extends StatefulWidget{
  _InvitationsState createState() => _InvitationsState();
}

class _InvitationsState extends BaseState<Invitations> {

  var session;

  bool accepted = false;
  bool declined = false;

  NavigationService navigationService;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){

    this.session = GetStorage().read(C.SESSION);
    this.navigationService = Modular.get<NavigationService>();

    return new Scaffold(
      body: Stack(
        children: <Widget> [
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: FutureBuilder(
              future: _fetch(),
              builder: (context, snapshot) {
                if(snapshot.hasData && snapshot.data.length > 0) {
                  return new ListView(
                    children:<Widget> [
                      ZeusHeader(),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 9, 0, 0),
                        child: Text("Latest Posts", style: TextStyle(fontSize: 32, fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
                      ),
                      for(var invitation in snapshot.data)
                       Card(
                           child: Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 30, 10),
                            child: Stack(
                              children: <Widget>[
//                                Container(
//                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                                    child: CircleAvatar(
//                                      radius: 40,
//                                      backgroundImage: NetworkImage(C.API_URI + invitation['imageUri']),
//                                    )
//                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    child:GestureDetector(
                                        child: Text(invitation['name'], style: TextStyle())
                                    )
                                ),
                                Container(
                                  child: Column(
                                      children: <Widget> [
                                        Container(
                                            child: RaisedButton(
                                                child: Text("Accept"),
                                                onPressed: !accepted ? () => _accept(invitation['inviteeId'].toString()) : null,
                                                color: Colors.lightBlue,
                                                textColor: Colors.white,
                                            )
                                        ),
//                                        Container(
//                                            padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
//                                            child: RaisedButton(
//                                                child: Text("Decline"),
//                                                onPressed: !declined ? () => _decline(invitation['inviteeId'].toString()) : null,
//                                                color: Colors.red,
//                                                textColor: Colors.white,
//                                            )
//                                        )
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                    ),
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0)
                                )
                              ]
                            )
                          )
                        )
                      ]
                    );
                }else if(snapshot.hasError){
                  return Center(child: Text("Something went wrong..."));
                }else{
                  return Column(
                    children: <Widget>[
                      ZeusHeader(),
                      Container(
                          padding: EdgeInsets.fromLTRB(10, 101, 10, 10),
                          child: Text("No invitations as of now!"))
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  );
                }
              },
            )
          ),
        ]
      )
    );
  }


  Future<List<dynamic>> _fetch() async {

    http.Response resp;

    try {
      resp = await http.get(
          C.API_URI + "friend/invitations",
          headers: {
            "cookie": this.session
          }
      );

      dynamic status = jsonDecode(resp.body.toString());
      return status;

    }catch(e){
      print("error $e");
    }
    return [];
  }


  Future _accept(id) async {

    http.Response resp;

    try {
      resp = await http.post(
          C.API_URI + "friend/accept/" + id,
          headers: {
            "cookie": this.session
          }
      );
      print(resp.body.toString());
      dynamic status = jsonDecode(resp.body.toString());
      if(status['success']){
        accepted = true;
        declined = true;
        super.showGlobalDialog("Congratulations, you have a new connection.", refresh);
      }

    }catch(e){
      print("error $e");
    }
    return null;
  }


  void refresh(){
    navigationService.navigateTo("/invitations");
  }


  Future _decline(id) async {

    http.Response getResponse;

    try {
      getResponse = await http.post(
          C.API_URI + "friend/decline/" + id,
          headers: {
            "cookie": this.session
          }
      );

      dynamic status = jsonDecode(getResponse.body.toString());
      if(status['success']){
        declined = true;
        accepted = true;
      }


    }catch(e){
      print("error $e");
    }
    return null;
  }

}