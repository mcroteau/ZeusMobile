import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:zeus/base.dart';
import 'package:zeus/common/c.dart';
import 'package:zeus/services/navigation_service.dart';

class SharePost extends StatefulWidget{
  @override
  _SharePostState createState() => _SharePostState();
}

class _SharePostState extends BaseState<SharePost>{

  dynamic post;
  String postId;
  String session;

  TextEditingController _controller;
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
    _controller = new TextEditingController();
    return Scaffold(
      appBar: new AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            navigationService.navigateTo("/posts");
          },
        ),
      ),
      body: getBody()
    );
  }

  Widget getBody(){
    return Stack(
        children: <Widget>[
          Container (
            child: FutureBuilder(
                future: _fetchPost(),
                builder: (context, snapshot) {
                  if(snapshot.hasData)
                    return Column(
                      children: <Widget>[
                        Row(
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(C.API_URI + snapshot.data['imageUri']),
                                    radius: 20,
                                  )
                              ),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                      hintText: "What do you want to say?"
                                  ),
                                  controller: _controller,
                                ),
                              ),
                            ]
                        ),
                        Align(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                              child: SizedBox(
                                height: 50,
                                child: RaisedButton(
                                  onPressed: () => _share(),
                                  color: Colors.lightBlue,
                                  child: new Text("Share " + post['name'] + "'s Post!", style: TextStyle(color:Colors.white)),
                                ),
                              ),
                              alignment: Alignment.topRight,
                            )
                        ),
                        Align(
                          child: Container(
                            padding: EdgeInsets.all(30),
                            child: post['content'] != null && post['content'] != "" ? Text('"' + post['content'] + '"') : Text("")
                          )
                        )
                      ],
                    );
                  else if(snapshot.hasError)
                    return Text("error");
                  else
                    return Center(child: CircularProgressIndicator());
                }
            )
          )
      ]
    );
  }


  FutureOr _fetchPost() async{
    http.Response getResponse = await http.get(
        C.API_URI + "post/" + this.postId,
        headers : {
          "cookie" : session
        }
    );
    print("get post data");
    this.post = jsonDecode(getResponse.body.toString());
    return this.post;
  }


  Future setSession() async {
    final prefs = await SharedPreferences.getInstance();
    this.session = prefs.get(C.SESSION);
    this.postId = prefs.get(C.POST_ID);
    navigationService = Modular.get<NavigationService>();
  }

  Future _share() async {
    print("_share " + this.postId);
    var req = http.MultipartRequest('post', Uri.parse(C.API_URI + "post/share_post/" + this.postId));
    req.headers['cookie'] = session;
    req.headers['Content-Type'] = "application/json";
    req.headers['Accept'] = "application/json";
    print("controller: $_controller.text");
    req.fields['comment'] = _controller.text;

    var response;

    try {
      http.StreamedResponse res = await req.send();
      response = await res.stream.bytesToString();
      print("response $response");

      var json = jsonDecode(response);
      if(json['error'] != null){
        super.showGlobalDialog("Please let us know, something went wrong", null);
      }
      else{
        _controller.text = "";
        super.showGlobalDialog("Successfully shared... check it.", _navigatePosts);
      }

    }catch(e){
      print("error $e");
    }
  }

  _navigatePosts() {
    navigationService.navigateTo('/posts');
  }
}