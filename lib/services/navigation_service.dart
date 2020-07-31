import 'package:flutter/cupertino.dart';
import 'package:zeus/model/zeus_data.dart';

class NavigationService {

  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }

  Future<dynamic> navigateToWithArgs(String routeName, ZeusData zeusData) {
    print("navigate " +  zeusData?.id.toString());
    return navigatorKey.currentState.pushNamed(routeName, arguments: zeusData);
  }

  void goBack() {
    navigatorKey.currentState.pop();
  }
}