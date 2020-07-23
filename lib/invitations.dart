import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/base.dart';
import 'package:zeus/common/c.dart';
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
    setSession().then((data){
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: Stack(
        children: <Widget> [
          Container(
            padding: EdgeInsets.fromLTRB(10, 72, 10, 10),
            child: FutureBuilder(
              future: _fetch(),
              builder: (context, snapshot) {
                if(snapshot.hasData && snapshot.data.length > 0) {
                  return new ListView(
                    children:<Widget> [
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
                  return Center( child: Text("No invitations as of now!"));
                }
              },
            )
          ),
          SearchBox(true)
        ]
      )
    );
  }


  Future<List<dynamic>> _fetch() async {

    final prefs = await SharedPreferences.getInstance();
    final session = prefs.get(C.SESSION);
    http.Response getResponse;

    try {
      getResponse = await http.get(
          C.API_URI + "friend/invitations",
          headers: {
            "cookie": session
          }
      );

      dynamic status = jsonDecode(getResponse.body.toString());
      return status;

    }catch(e){
      print("error $e");
    }
    return [];
  }


  Future _accept(id) async {

    final prefs = await SharedPreferences.getInstance();
    final session = prefs.get(C.SESSION);
    http.Response getResponse;

    try {
      getResponse = await http.post(
          C.API_URI + "friend/accept/" + id,
          headers: {
            "cookie": session
          }
      );
      print(getResponse.body.toString());
      dynamic status = jsonDecode(getResponse.body.toString());
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

    final prefs = await SharedPreferences.getInstance();
    final session = prefs.get(C.SESSION);
    http.Response getResponse;

    try {
      getResponse = await http.post(
          C.API_URI + "friend/decline/" + id,
          headers: {
            "cookie": session
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


  Future setSession() async{
    final prefs = await SharedPreferences.getInstance();
    this.session = prefs.get(C.SESSION);
    navigationService = Modular.get<NavigationService>();
    setState(() {});
  }

}