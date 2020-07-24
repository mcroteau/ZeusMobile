import 'dart:async';
import 'dart:collection';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:video_box/video_box.dart';
import 'package:video_box/video.controller.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:zeus/base.dart';
import 'dart:convert';
import 'package:zeus/common/c.dart';
import 'package:zeus/services/navigation_service.dart';


class SearchResultsFutureBuilder extends StatefulWidget{
  @override
  _SearchResultsBuilderState createState() => _SearchResultsBuilderState();
}

class _SearchResultsBuilderState extends BaseState<SearchResultsFutureBuilder>{

  String q = "";
  String session = "";
  BuildContext context;
  MediaQueryData mediaQuery;
  NavigationService navigationService;

  Map<String, Object> data;

  @override
  void initState(){
    super.initState();
    setQ().then((data) {
      setState(() {});
    });
  }

  @override
  Widget build(context) {
    this.context = context;
    this.mediaQuery = MediaQuery.of(context);
    this.data = ModalRoute.of(context).settings.arguments;
    return new FutureBuilder<dynamic>(
        future: _fetch(),
        builder: (context, snapshot) {
          if (snapshot != null && snapshot.data != null && snapshot.hasData && snapshot.data['accounts'] != null) {
            return new ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text("Search Results", style: TextStyle(fontSize: 32, fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
                  ),
                  for (var p in snapshot.data['accounts'])
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Card(
                            elevation: 1,
                            child: Align(
                                child: Row(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                          child: GestureDetector(
                                            onTap: (){
                                              setProf(p['id'].toString()).then((data){
                                                 navigationService.navigateTo('/profile');
                                              });
                                            },
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(C.API_URI + p['imageUri']),
                                              radius: 40,
                                            )
                                          ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                            Container(
                                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                              child:  GestureDetector(
                                                onTap: (){
                                                  setProf(p['id'].toString()).then((data){
                                                    navigationService.navigateTo('/profile');
                                                  });
                                                },
                                                child: Text(p['name'], overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400))
                                              )
                                          ),

                                          if(p['location'] != null)
                                            Container(
                                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                child:  GestureDetector(
                                                    child: Text(p['location'], textAlign: TextAlign.left)
                                                )
                                            ),

                                          if(p['isFriend'])
                                            Container(
                                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              child: Text("Friends", style: TextStyle(fontSize:10)),
                                            )

                                    ],
                                  )
                                ],
                            )
                        )
                    ),
                 ),
                ]
            );
          } else if (snapshot.hasError) {
            return Text("error: ${snapshot.error}");
          }else if(snapshot.data['error'] != null){
            return Text("error: " + snapshot.data['error']);
          }
          // By default, show a loading spinner.
          return Center( child: CircularProgressIndicator());
        }
    );
  }

  FutureOr<dynamic> _fetch() async {
    print("_fetch $q");
    http.Response postResponse = await http.get(
        C.API_URI + "search?q=" + q,
        headers : {
          "cookie" : session
        }
    );
    print("getting data");
    dynamic data = jsonDecode(postResponse.body.toString());
    return data;
  }

  Future setQ() async{
    final prefs = await SharedPreferences.getInstance();
    this.session = prefs.get(C.SESSION);
    this.q = prefs.get(C.Q);
    navigationService = Modular.get<NavigationService>();
  }

  Future setProf(String id) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(C.ID, id);
  }

}