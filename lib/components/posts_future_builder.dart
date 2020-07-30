import 'package:flutter_html/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:video_box/video_box.dart';
import 'package:video_box/video.controller.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zeus/common/c.dart';
import 'package:zeus/components/posts_bottom_content.dart';
import 'package:zeus/components/posts_header.dart';
import 'package:zeus/services/navigation_service.dart';


class PostsFutureBuilder extends StatelessWidget {

  BuildContext context;
  MediaQueryData mediaQuery;
  TextEditingController controller;
  NavigationService navigationService;

  PostsFutureBuilder(){
    navigationService = Modular.get<NavigationService>();
  }


  @override
  Widget build(context) {
    this.context = context;
    this.mediaQuery = MediaQuery.of(context);
    this.controller = new TextEditingController();

    double _width = MediaQuery.of(context).size.width*0.57;

    return new FutureBuilder<dynamic>(
        future: _fetch(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            return new ListView(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 171),
                children: <Widget>[
                  PostsHeader(),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 91, 0, 0),
                    child: Text("Latest Posts", style: TextStyle(fontSize: 32, fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
                  ),
                  for (var p in snapshot.data)
                    if(!p['hidden'])
                      Card(
//                          child: Container(
//                              padding: const EdgeInsets.fromLTRB(0, 22, 0, 10),
//                              color: Colors.white,
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black12
                                    ),
                                    color: Colors.white54,
                                  ),
                                  child: Column(
                                      children: <Widget>[
                                        if(p['shared'])
                                          Container(
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                     Align(
                                                         child:Container(
                                                           width:70,
                                                           padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                                                           child: GestureDetector(
                                                              child:  Image.network(C.API_URI + p['sharedImageUri'], width: 50),
                                                              onTap: () => {
                                                                _setProfileId(p['sharedAccountId']).then((data){
                                                                  navigationService.navigateTo('/profile');
                                                                })
                                                              },
                                                            )
                                                        ),
                                                       alignment: Alignment.topLeft,
                                                    ),
                                                    Align(
                                                      child: Column(
                                                        children: <Widget> [
                                                          Container(
                                                            padding:EdgeInsets.fromLTRB(0, 10, 0, 0),
                                                            child: GestureDetector(
                                                              child:Text(p['sharedAccount'], style: TextStyle( color: Colors.white ),textAlign: TextAlign.left,),
                                                              onTap: () => {
                                                                _setProfileId(p['sharedAccountId']).then((data){
                                                                  navigationService.navigateTo('/profile');
                                                                })
                                                              },
                                                            ),
                                                            alignment: Alignment.centerLeft,
                                                          ),
                                                          Container(
                                                              padding:EdgeInsets.fromLTRB(0, 0, 0, 10),
                                                              child: Text(p['timeSharedAgo'], style: TextStyle( color: Colors.white ), textAlign: TextAlign.left,),
                                                              alignment: Alignment.centerLeft,
                                                          ),
                                                          Container(
                                                              width: _width,
                                                              padding:EdgeInsets.fromLTRB(0, 0, 10, 20),
                                                              child: Text(p['sharedComment'], style: TextStyle( color: Colors.white ), textAlign: TextAlign.left,),
                                                              alignment: Alignment.centerLeft,
                                                          )
                                                        ],
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start
                                                      ),
                                                    ),
                                                    Align(
                                                      child: Container(
                                                          width: 70,
                                                          padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                                                          child: Text("Shared", style: TextStyle(color: Colors.white, fontSize:10), textAlign: TextAlign.right,)
                                                      ),
                                                      alignment: Alignment.topRight,
                                                    ),
                                                  ],
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  )
                                                ],
                                            ),
                                            color: Colors.lightBlue,
                                          ),
                                        if(p['videoFileUri'] != null)
                                          Container(
                                            child: AspectRatio(
                                              aspectRatio: _calculateAspectRatio(context),
                                              child: new VideoBox(controller: _getVideoController(C.API_URI + p['videoFileUri'])),
                                            ),
                                          ),
                                        if(p['imageFileUris'] != null)
                                          for(var imageUri in p['imageFileUris'])
                                            Container( child: Image.network(C.API_URI + imageUri, fit: BoxFit.cover, width: mediaQuery.size.width)),
                                        if(p['content'] != null)
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.fromLTRB(0, 15, 20, 10),
                                              child: Html(
                                                data: p['content'],
                                                style: {
                                                  "a" : Style( fontSize: FontSize.xLarge ),
                                                  "html" : Style( fontSize: FontSize.xLarge, fontWeight: FontWeight.w300)
                                                },
                                              )
                                            ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 6, // 60% of space => (6/(6 + 4))
                                              child: Container(
                                                height: 5,
                                                color: Colors.lightBlue,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3, // 60% of space => (6/(6 + 4))
                                              child: Container(
                                                height: 5,
                                                color: Colors.lightGreen,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1, // 60% of space => (6/(6 + 4))
                                              child: Container(
                                                height: 5,
                                                color: Colors.yellow,
                                              ),
                                            )
                                          ],
                                        ),
                                        PostsBottomContent(p),
                                      ]
                                  ),
//                              )
                          ),
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        elevation: 0,
                      )
                ]
            );
          } else if (snapshot.hasError) {
            return Text("error: ${snapshot.error}");
          }else{
            return Center(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 49, 40, 0),
                child:Column(
                    children: <Widget>[
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur...", textAlign: TextAlign.left,),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text("all of this means you need to share something!", textAlign: TextAlign.left,),
                      color: Colors.yellowAccent,
                    )
                  ],
                ),
              ),
            );
          }
          return Center( child: CircularProgressIndicator());
        }
    );
  }

  VideoController _getVideoController(String uri){
    print(uri);
    VideoController vc = VideoController(source: VideoPlayerController.network(uri));
    return vc;
  }

   Future<List<dynamic>> _fetch() async {

    final prefs = await SharedPreferences.getInstance();
    final session = prefs.get(C.SESSION);
    http.Response postResponse;

    try {
      postResponse = await http.get(
          C.API_URI + "posts",
          headers: {
            "cookie": session
          }
      );

      List<dynamic> posts = jsonDecode(postResponse.body.toString());
      return posts;

    }catch(e){
      navigationService.navigateTo('/');
    }
    return [];
  }

  double _calculateAspectRatio(BuildContext context) {
//    final size = mediaQuery.size;
//    final width = size.width;
//    final height = size.height;

//    return width > height ? width / height : height / width;
    return 16/9;
  }

  Future _setProfileId(id) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(C.ID, id.toString());
  }


}