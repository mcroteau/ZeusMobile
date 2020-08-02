import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:zeus/common/c.dart';
import 'package:zeus/posts.dart';
import 'package:zeus/profile.dart';
import 'package:zeus/services/navigation_service.dart';
import 'package:zeus/share_post.dart';

class PostsBottomContent extends StatelessWidget {

  dynamic post;

  String session;

  BuildContext context;
  NavigationService navigationService;

  PostsBottomContent(post){
    this.post = post;
    navigationService = Modular.get<NavigationService>();
    print("posts butt: " + this.navigationService.toString());
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    this.session = GetStorage().read(C.SESSION);
    return Stack(
      alignment: Alignment.topLeft,
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: GestureDetector(
            onTap: () => {
              _storeProfileId(post['accountId']).then((data){
                navigationService.navigateTo('/profile');
              })
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(11, 13, 0, 0),
              child: Image.network(C.API_URI + post['imageUri'], width: 50),
            ),
          ),
        ),
        Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () => {
                _storeProfileId(post['accountId']).then((data){
                  navigationService.navigateTo('/profile');
                })
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(71, 13, 0, 0),
                child: GestureDetector(
                  child: Text(post['name'], style: TextStyle( fontSize: 19, fontWeight: FontWeight.w700 )),
                  onTap: () => {
                    _storeProfileId(post['accountId']).then((data){
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
                _storeProfileId(post['accountId']).then((data){
                  navigationService.navigateTo('/profile');
                });
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(71, 36, 0, 0),
                child: Text(post['timeAgo'], style: TextStyle(fontSize: 16))
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
                             _storePostId(post['id']).then((data){
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
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget> [
              Container(
                  padding: EdgeInsets.fromLTRB(0, 130, 0, 3),
                  child: MaterialButton(
                    child: Text("x", style: TextStyle(fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                    onPressed: () =>
                    {
                      unshare(post['postShareId'])
                    },
                    minWidth: 10,
                  )
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(0, 130, 0, 3),
                    child: MaterialButton(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.flag, size: 13, color:Colors.white),
                          Container(
                            margin: EdgeInsets.fromLTRB(3, 0, 0, 0),
                            child: Text("Report", style: TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                      onPressed: () =>
                      {
                        _confirmation("Are you sure you would like to flag this post?")
                      },
                      minWidth: 15,
                    )
                ),
            ],
          )
        else if(post['deletable'])
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 130, 0, 3),
                  child: MaterialButton(
                    child: Text("x", style: TextStyle(fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                    onPressed: () =>
                    {
                      deletePost(post['id'])
                    },
                    minWidth: 10,
                  )
                ),
                Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(0, 130, 0, 3),
                    child: MaterialButton(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.flag, size: 13, color:Colors.white),
                          Container(
                            margin: EdgeInsets.fromLTRB(3, 0, 0, 0),
                            child: Text("Report", style: TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                      onPressed: () =>
                      {
                        _confirmation("Are you sure you would like to flag this post?")
                      },
                    )
                ),
              ]
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget> [
            Container(
              padding: EdgeInsets.fromLTRB(0, 130, 0, 3),
              child: MaterialButton(
                child: Row(
                    children: <Widget>[
                        Icon(Icons.flag, size: 13, color:Colors.white),
                        Container(
                          margin: EdgeInsets.fromLTRB(3, 0, 0, 0),
                          child: Text("Report", style: TextStyle(color: Colors.white)),
                        )
                    ],
                  ),
                onPressed: () =>
                  {
                  _confirmation("Are you sure you would like to flag this post?")
                  },
                  minWidth: 15,
                )
              ),
            ]
          )
      ]
    );
  }

  Future _storeProfileId(id) async{
    await GetStorage().write(C.ID, id);
  }


  Future _storePostId(id) async{
    GetStorage().write(C.POST_ID, id);
  }


  Future _like(id) async {

    http.Response getResponse;

    try {
      getResponse = await http.post(
          C.API_URI + "post/like/" + id.toString(),
          headers: {
            "cookie": this.session
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


  Future deletePost(id) async {

    http.Response getResponse;

    try {
      getResponse = await http.delete(
          C.API_URI + "post/remove/$id",
          headers: {
            "cookie": this.session
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

    http.Response resp;

    try {
      resp = await http.delete(
          C.API_URI + "post/unshare/$id",
          headers: {
            "cookie": this.session
          }
      );
      print(resp.body.toString());
      dynamic status = jsonDecode(resp.body.toString());
      if(status['success']){
      }
      navigationService.navigateTo('/posts');
    }catch(e){
      print("error $e");
    }
    return null;
  }

  Future _flag(id, shared) async {
    print("flag post/flag/$id/$shared");

    http.Response getResponse;

    try {
      getResponse = await http.post(
          C.API_URI + "post/flag/$id/$shared",
          headers: {
            "cookie": this.session
          }
      );
      print(getResponse.body.toString());
      dynamic status = jsonDecode(getResponse.body.toString());
      if(status['success']){
        showGlobalDialog("Successfully flagged it! Thank you!", navigatePosts);
      }
    }catch(e){
      print("error $e");
    }
    return null;
  }

  void navigatePosts(){
    navigationService.navigateTo('/posts');
  }

  void showGlobalDialog(String content, Function funct){
      showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Message"),
              content: new Text(content),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Okay!"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if(funct != null)
                      funct.call();
                  },
                ),
              ],
            );
          }
      );
  }

  void _confirmation(message){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Message"),
            content: new Text(message),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                }
              ),
              new FlatButton(
                child: new Text("Flag Post!"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _flag(post['id'], false);
                },
              ),
            ],
          );
        }
    );
  }
}