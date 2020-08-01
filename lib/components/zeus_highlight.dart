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

class ZeusHighlight extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 6, // 60% of space => (6/(6 + 4))
          child: Container(
            height: 7,
            color: Colors.lightBlue,
          ),
        ),
        Expanded(
          flex: 3, // 60% of space => (6/(6 + 4))
          child: Container(
            height: 7,
            color: Colors.green,
          ),
        ),
        Expanded(
          flex: 1, // 60% of space => (6/(6 + 4))
          child: Container(
            height: 7,
            color: Colors.yellow,
          ),
        )
      ],
    );
  }

}