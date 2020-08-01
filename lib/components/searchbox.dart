import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';

import 'package:zeus/base.dart';
import 'package:zeus/common/c.dart';
import 'package:zeus/components/searchbox_content.dart';
import 'package:zeus/services/navigation_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchBox extends StatelessWidget{

  var id;
  bool alignUp;

  SearchBox(bool alignUp){
    this.alignUp = alignUp;
  }

  @override
  Widget build(BuildContext context) {
    if(alignUp)
      return new Positioned(
          top:17,
          left:2,
          right: 2,
          child: SearchBoxContent()
      );
    if(!alignUp)
      return new Positioned(
          bottom:9,
          left:10,
          right: 10,
          child: SearchBoxContent()
      );

  }

}