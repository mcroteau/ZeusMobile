import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:zeus/authenticate.dart';
import 'package:zeus/base.dart';
import 'package:http/http.dart' as http;
import 'package:zeus/common/c.dart';
import 'package:zeus/components/zeus_header.dart';
import 'package:zeus/components/zeus_highlight.dart';
import 'package:zeus/services/navigation_service.dart';
import 'dart:convert';

import 'components/searchbox.dart';

class Profile extends StatefulWidget{
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends BaseState<Profile> with AutomaticKeepAliveClientMixin<Profile>{

  @override
  bool get wantKeepAlive => true;

  _ProfileState({Key key, @required this.data});

  var radius = 70.0;
  var topHeight = 170.0;

  var id;
  var session;

  var friends = [];
  dynamic profile;
  dynamic viewsData;
  dynamic data;

  bool requestSent = false;
  bool blocked = false;
  String blockedText = "Block Person";

  Future<dynamic> _loadingProfile;

  NavigationService navigationService;

  @override
  void initState(){
    _loadingProfile = _fetchProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    super.build(context);
    this.session = GetStorage().read(C.SESSION);
    this.navigationService = Modular.get<NavigationService>();
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body:
      FutureBuilder(
          future: _loadingProfile,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else
                  return new ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 101),
                      children: <Widget>[
                        ZeusHeader(),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Image.network(C.API_URI + profile['imageUri'], width: 50)
                        ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Column(
                          children: [
                            Text(profile['name'], style: TextStyle(color: Colors.black, fontSize: 27, fontWeight: FontWeight.w900, decoration: TextDecoration.none, fontFamily: "Roboto")),
                            Container(
                              child: Text(profile['location'] != null ? profile['location'] : "", style: TextStyle(color: Colors.black, fontSize: 14, decoration: TextDecoration.none))
                            ),

                            if(profile['isFriend'])
                              Container(
                                  child: Text("Friends")
                              ),

                            if(!profile['isFriend'] && !profile['isOwnersAccount'])
                              Container(
                                child:  RaisedButton(
                                    child: Text("Send Buddy Request"),
                                    elevation: 3,
                                    color: Colors.yellow,
                                    textColor: Colors.black,
                                    onPressed: !requestSent ? () => _sendReq(profile['id'].toString()) : null
                                )
                              ),

                            if(viewsData != null)
                              Row(
                                children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              child:Text(viewsData['week'].toString())
                                            ),
                                            Text("Week Visits")
                                          ],
                                        )
                                      )
                                    ),
                                    Expanded(
                                        flex: 4,
                                        child: Container(
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                    child:Text(viewsData['month'].toString())
                                                ),
                                                Text("Month Visits")
                                              ],
                                            )
                                        )
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: Container(
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                    child:Text(viewsData['all'].toString())
                                                ),
                                                Text("All Time Visits")
                                              ],
                                            )
                                        )
                                      )
                                    ],
                                  ),
                                ]
                              )
                            ),

                        for(var friend in friends)
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
                                  child: GestureDetector(
                                    onTap: (){
                                      _storeProfileId(friend['friendId'].toString()).then((data){
                                        navigationService.navigateTo('/profile');
                                      });
                                    },
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(C.API_URI + friend['imageUri']),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(40, 10, 0, 0),
                                  child: GestureDetector(
                                    onTap: (){
                                      _storeProfileId(friend['friendId'].toString()).then((data){
                                        navigationService.navigateTo('/profile');
                                      });
                                    },
                                    child: Text(friend['name'], style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal, fontFamily: "Roboto", decoration: TextDecoration.none)),
                                )
                              )
                            ],
                          ),

                        if(!profile['isOwnersAccount'])
                          Column(
                            children: <Widget> [
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 49, 0, 0),
                                  child:  RaisedButton(
                                      color: Colors.white,
                                      child: Text(blockedText),
                                      elevation: 3,
                                      onPressed: () =>  _block(profile['id'])
                                  )
                              ),
                            ]
                          )
                      ]
                  );
            }
          }
      )
    );
  }


  Future _storeProfileId(id) async{
    GetStorage().write(C.ID, id);
  }

  FutureOr<dynamic> _fetchProfile() async{
    var id = await GetStorage().read(C.ID);
    print("profile id : " + this.id.toString());

    http.Response profileData = await http.get(
        C.API_URI + "profile/" + id.toString(),
        headers : {
          "content-type": "application/json",
          "accept": "application/json",
          "cookie" : this.session
        }
    );

    var data = jsonDecode(profileData.body.toString());
    profile = data['profile'];
    friends = data['friends'];

    setBlockedButton();

    if(profile['isOwnersAccount']) {
      http.Response viewsResp = await http.get(
          C.API_URI + "profile/data/views",
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            "cookie": this.session
          }
      );
      viewsData = jsonDecode(viewsResp.body.toString());
    }

    if(data['error'] != null){
      navigationService.navigateTo('/authenticate');
    }

    this.data = data;
    return data;
  }

  Future<dynamic> _sendReq(id) async {
    super.showGlobalDialog("Sending...", null);
    http.Response req = await http.post(
        C.API_URI + "friend/invite/" + id,
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "cookie": this.session
        }
    );

    print(req.body.toString());
    var data = jsonDecode(req.body.toString());

    if(data['success']){
      super.showGlobalDialog("Successfully sent buddy request.", null);
      setState(() {
        requestSent = true;
      });
    }else{
      super.showGlobalDialog("Whoa, apologies, there was an issue, please try again...", null);
      return null;
    }
  }

  void setBlockedButton(){

    print('profile' + profile.toString());
    if(profile != null && profile['blocked']){
      print("blocked!");
      setState(() {
        blocked = true;
        blockedText = "Blocked!";
      });
    }
  }

  Future<dynamic> _block(id) async {
    await GetStorage().write(C.ID, id);
    if(blocked) {
      super.confirmation(
          "Are you sure you want to unblock this person?",
          _performBlock);
    }else{
      super.confirmation(
          "Are you sure you want to block this person? He/she will not be able view your profile and you will not show up in searches by this user. Is this ok?",
          _performBlock);
    }
  }

  Future<dynamic> _performBlock() async{
    var id = await GetStorage().read(C.ID);
    http.Response req = await http.post(
        C.API_URI + "profile/block/" + id.toString(),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "cookie": this.session
        }
    );

    print(req.body.toString());
    var data = jsonDecode(req.body.toString());

    if(data['success'] != null){

      if(data['success'] == "blocked") {
        super.showGlobalDialog("Blocked person.", null);
        setState(() {
          blocked = true;
          blockedText = "Blocked!";
        });
      }else{
        setState(() {
          blocked = true;
          blockedText = "Block Person";
        });
      }
    }else{
      super.showGlobalDialog("Whoa, apologies, there was an issue, please try again...", null);
      return null;
    }
  }

}