import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_storage/get_storage.dart';

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

  File _video;
  File _image;
  final picker = ImagePicker();
  String message = "";
  String session;

  bool publishing = false;

  TextEditingController controller;
  NavigationService navigationService;

  @override
  void initState(){
    super.initState();
    _image = null;
    _video = null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    this.session = GetStorage().read(C.SESSION);
    this.controller = new TextEditingController();
    this.navigationService = Modular.get<NavigationService>();

    return new Scaffold(
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
                  Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.fromLTRB(20, 60, 30, 30),
                      child: GestureDetector(
                        child: Icon(Icons.arrow_back),
                        onTap: () => {
                          navigationService.goBack()
                        },
                      )
                  ),
                 Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.fromLTRB(20, 30, 30, 30),
                      child: Text("Publish Post", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 29))
                 ),
                 Row(
                     children: <Widget>[
                       Container(
                           padding: EdgeInsets.fromLTRB(20, 0, 10, 10),
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
                   padding: EdgeInsets.fromLTRB(7, 30, 0, 10),
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
                           color: Colors.yellowAccent,
                           child: new Text("Share!", style: TextStyle(fontSize:17, fontWeight: FontWeight.w700, color: Colors.black)),
                           padding: EdgeInsets.fromLTRB(49, 15, 49, 15),
                           shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(28.0),
                               side: BorderSide(color: Colors.white, width: 3)
                           ),
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


  Future _openImageExplorer() async {
    print("open image explorer");
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
      message = "Image Selected";
    });

  }

  Future openVideoExplorer() async {
    _video = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['mp4']
    );
  }


  Future _publish() async {
    print("publish $_image");


    if(!publishing) {

      if (controller.text == "" &&
          _image == null &&
          _video == null) {
        super.showGlobalDialog("You didn't say anything, what's up?", null);
        return false;
      }

      setState(() {
        publishing = true;
      });

      super.showGlobalDialogNoOkay("Publishing, please wait... it has to go through the internets and stuff.", null);

      var req = http.MultipartRequest(
          'post', Uri.parse(C.API_URI + "post/share"));
      req.headers['cookie'] = this.session;
      req.headers['Content-Type'] = "application/json";
      req.headers['Accept'] = "application/json";

      print("controller: $controller.text");

      req.fields['content'] = controller.text;

      if (_image != null) {
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
      
      var response;

      try {
        http.StreamedResponse resp = await req.send();
        response = await resp.stream.bytesToString();
        print("response $response");

        var json = jsonDecode(response);
        if (json['error'] != null) {
          navigationService.goBack();
          super.showGlobalDialog(
              "Something went wrong. Images must be either jpg, png or gif",
              null);
        }
        else {
          navigationService.goBack();
          controller.text = "";
          super.showGlobalDialog(
              "Successfully published post... check it.", navigatePosts);
        }

        setState(() {
          publishing = false;
        });

      } catch (e) {
        print("error $e");
      }
    }

  }

  void navigatePosts(){
    navigationService.navigateTo('/posts');
  }


}