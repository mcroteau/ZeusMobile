import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:zeus/base.dart';
import 'package:zeus/common/c.dart';
import 'package:zeus/components/searchbox.dart';
import 'package:zeus/services/navigation_service.dart';
import 'package:image_picker/image_picker.dart';

class Publish extends StatefulWidget{
  _PublishState createState() => _PublishState();
}

class _PublishState extends BaseState<Publish>{

  File video;
  File _image;
  final picker = ImagePicker();
  String message = "";

  TextEditingController controller;
  NavigationService navigationService;


  @override
  void initState(){
    super.initState();
    _image = null;
    video = null;
    controller = new TextEditingController();
    navigationService = Modular.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
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
      body:getBody(),
      backgroundColor: Colors.white,
    );
  }

  Widget getBody(){
    return new FutureBuilder(
          future: _fetch(),
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
                         child: Container(
                           padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                           child: TextField(
                             decoration: InputDecoration(
                                 hintText: "What's on your mind?",
                             ),
                             controller: controller,
                             keyboardType: TextInputType.multiline,
                             minLines: 1,//Normal textInputField will be displayed
                             maxLines: 13,
                           ),
                         ),
                       )
                     ]
                 ),
                 Container(
                   padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                   child: MaterialButton(
                       onPressed: () =>
                           _openImageExplorer(),
                       child: Row(
                           children: <Widget>[
                             new Text("Image"),
                             new Icon(Icons.image, color: Colors.green),
                             new Text(message)
                           ]
                       )
                   ),
                 ),
                 Align(
                     child: Container(
                       padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                       child: SizedBox(
                         height: 50,
                         child: RaisedButton(
                           onPressed: () => _publish(),
                           color: Colors.lightBlue,
                           child: new Text("Publish Post!", style: TextStyle(color:Colors.white)),
                         ),
                       ),
                       alignment: Alignment.topRight,
                     )
                 )
               ],
             );
          else if(snapshot.hasError)
            return Text("error");
          else
            return Center(child: CircularProgressIndicator());
        }
      );
  }

  Future<dynamic> _fetch() async {
    final prefs = await SharedPreferences.getInstance();
    final session = prefs.get(C.SESSION);

    http.Response postResponse = await http.get(
        C.API_URI + "account/info",
        headers : {
          "content-type": "application/json",
          "accept": "application/json",
          "cookie" : session
        }
    );

    var info = jsonDecode(postResponse.body.toString());
    return info;
  }


  Future _openImageExplorer() async {
    print("open image explorer");
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
      message = "Image Selected";
    });

  }

  Future openVideoExplorer() async {
    video = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['mp4']
    );
  }


  Future _publish() async {
    var pref = await SharedPreferences.getInstance();
    String session = pref.get(C.SESSION);
    
    print("publish $_image");
    
    var req = http.MultipartRequest('post', Uri.parse(C.API_URI + "post/share"));
    req.headers['cookie'] = session;
    req.headers['Content-Type'] = "application/json";
    req.headers['Accept'] = "application/json";
    
    print("controller: $controller.text");
    
    req.fields['content'] = controller.text;
    
    if(_image != null) {
      req.files.add(
          http.MultipartFile(
              'imageFiles',
              _image.readAsBytes().asStream(),
              _image.lengthSync(),
              filename: _image
                  .toString()
                  .split("/")
                  .last
          )
      );
    }

    if(controller.text == "" &&
        _image == null &&
          video == null){
      super.showGlobalDialog("You didn't say anything, what's up?", null);
      return false;
    }

    var response;

    try {
      http.StreamedResponse res = await req.send();
      response = await res.stream.bytesToString();
      print("response $response");

      var json = jsonDecode(response);
      if(json['error'] != null){
        super.showGlobalDialog("Something went wrong. Images must be either jpg, png or gif", null);
      }
      else{
        controller.text = "";
        super.showGlobalDialog("Successfully published post... check it.", navigatePosts);
      }

    }catch(e){
      print("error $e");
    }

  }

  void navigatePosts(){
    navigationService.navigateTo('/posts');
  }


}