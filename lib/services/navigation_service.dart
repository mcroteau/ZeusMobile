import 'package:flutter/cupertino.dart';

class NavigationService {

  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }

  Future<dynamic> navigateToWithArgs(String routeName, dynamic obj) {
    print("navigate");
    return navigatorKey.currentState.pushNamed(routeName, arguments: obj);
  }

  void goBack() {
    navigatorKey.currentState.pop();
  }
}