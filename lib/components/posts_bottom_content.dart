import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:zeus/common/c.dart';
import 'package:zeus/services/navigation_service.dart';

class PostsBottomContent extends StatelessWidget {

  dynamic post;
  NavigationService navigationService;

  PostsBottomContent(post){
    this.post = post;
    navigationService = Modular.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: GestureDetector(
            onTap: () => {
              _setProfileId(post['accountId']).then((data){
                navigationService.navigateTo('/profile');
              })
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(4, 10, 0, 0),
              child: Image.network(C.API_URI + post['imageUri'], width: 50),
            ),
          ),
        ),
        Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () => {
                _setProfileId(post['accountId']).then((data){
                  navigationService.navigateTo('/profile');
                })
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(67, 10, 0, 0),
                child: GestureDetector(
                  child: Text(post['name'], style: TextStyle( fontWeight: FontWeight.w700, fontSize: 14 )),
                  onTap: () => {
                    _setProfileId(post['accountId']).then((data){
                      navigationService.navigateTo('/profile');
                    })
                  },
                )
              )
            )
        ),
        Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: (){
                _setProfileId(post['accountId']).then((data){
                  navigationService.navigateTo('/profile');
                });
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(67, 30, 0, 0),
                child: Text(post['timeAgo'])
              )
          )
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 70, 30, 23),
                  child: Row(
                    children: <Widget> [
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 3, 0),
                        child: Text(post['shares'].toString()),
                       ),
                       Container(
                         padding: EdgeInsets.fromLTRB(0, 10, 3, 0),
                         child: Text("Shares"),
                       ),
                       Container(
                         padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                         child: GestureDetector(
                           onTap: () {
                             _setPostId(post['id']).then((data){
                               navigationService.navigateTo('/share_post');
                             });
                           },
                           child: Text("∆", style: TextStyle(fontSize: 29, fontWeight: FontWeight.w700, color: Colors.deepOrangeAccent)),
                         )
                       )
                     ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 70, 30, 23),
                  child: Row(
                    children: <Widget> [
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 3, 0),
                        child: Text(post['likes'].toString()),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 3, 0),
                        child: Text("Likes"),
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            _like(post['id']).then((data){
                              navigationService.navigateTo('/posts');
                            });
                          },
                          child: Text("π", style: TextStyle( fontSize: 32, fontWeight: FontWeight.w700, color: Colors.lightBlue)),
                        )
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ),
        if(post['shared'] && post['deletable'])
            Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                    padding: EdgeInsets.fromLTRB(0, 110, 0, 20),
                    child: MaterialButton(
                        child: Text("x", style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: Colors.black12)),
                        onPressed: () => {
                          unshare(post['postShareId'])
                        },
                        minWidth: 15,
                    )
                )
            )
        else if(post['deletable'])
            Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                    padding: EdgeInsets.fromLTRB(0, 110, 0, 20),
                    child: MaterialButton(
                        child: Text("x", style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: Colors.black12)),
                        onPressed: () => {
                          deletePost(post['id'])
                        },
                        minWidth: 15,
                    )
                )
            )
      ]
    );
  }

  Future _setPostId(id) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(C.POST_ID, id.toString());
  }


  Future _like(id) async {

    final prefs = await SharedPreferences.getInstance();
    final session = prefs.get(C.SESSION);
    http.Response getResponse;

    try {
      getResponse = await http.post(
          C.API_URI + "post/like/" + id.toString(),
          headers: {
            "cookie": session
          }
      );
      print(getResponse.body.toString());
      dynamic status = jsonDecode(getResponse.body.toString());
      if(status['success']){
      }

    }catch(e){
      print("error $e");
    }
    return null;
  }

  Future _setProfileId(id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(C.ID, id.toString());
  }

  Future deletePost(id) async {
    final prefs = await SharedPreferences.getInstance();
    final session = prefs.get(C.SESSION);
    http.Response getResponse;

    try {
      getResponse = await http.delete(
          C.API_URI + "post/remove/$id",
          headers: {
            "cookie": session
          }
      );
      print(getResponse.body.toString());
      dynamic status = jsonDecode(getResponse.body.toString());
      if(status['success']){
      }

      navigationService.navigateTo('/posts');

    }catch(e){
      print("error $e");
    }
    return null;
  }


  Future unshare(id) async {
    print("unshare");
    final prefs = await SharedPreferences.getInstance();
    final session = prefs.get(C.SESSION);
    http.Response getResponse;

    try {
      getResponse = await http.delete(
          C.API_URI + "post/unshare/$id",
          headers: {
            "cookie": session
          }
      );
      print(getResponse.body.toString());
      dynamic status = jsonDecode(getResponse.body.toString());
      if(status['success']){
      }
      navigationService.navigateTo('/posts');
    }catch(e){
      print("error $e");
    }
    return null;
  }
}