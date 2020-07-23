import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:zeus/common/c.dart';
import 'package:zeus/register.dart';
import 'package:zeus/share_post.dart';
import 'package:zeus/zero.dart';
import 'package:zeus/profile.dart';
import 'package:zeus/publish.dart';
import 'package:zeus/search.dart';
import 'package:zeus/services/navigation_service.dart';
import 'package:zeus/authenticate.dart';
import 'package:zeus/posts.dart';

import 'invitations.dart';


Future<void> main() async {
  runApp(ModularApp(module: InitModule()));
}

class ZeusApp extends StatefulWidget {
  ZeusAppState createState() => ZeusAppState();
}

class ZeusAppState extends State<ZeusApp>{

  NavigationService navigationService;

  @override
  void initState(){
    super.initState();
    initiateAuthenticationCheck().then((data) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    navigationService = Modular.get<NavigationService>();
    return MaterialApp(
          navigatorKey: navigationService.navigatorKey,
          onGenerateRoute: (routeSettings) {
            switch (routeSettings.name) {
              case '/':
                return MaterialPageRoute(builder: (context) => Zero());
              case '/search':
                return MaterialPageRoute(builder: (context) => Search());
              case '/posts':
                return MaterialPageRoute(builder: (context) => Posts());
              case '/share_post':
                return MaterialPageRoute(builder: (context) => SharePost());
              case '/profile':
                return MaterialPageRoute(builder: (context) => Profile());
              case '/invitations':
                return MaterialPageRoute(builder: (context) => Invitations());
              case '/authenticate':
                return MaterialPageRoute(builder: (context) => Authenticate());
              case '/register':
                return MaterialPageRoute(builder: (context) => Register());
              default:
                return MaterialPageRoute(builder: (context) => Zero());
            }
        },
    );
  }

  Future initiateAuthenticationCheck() async {
    final prefs = await SharedPreferences.getInstance();
    String session = prefs.getString(C.SESSION);

    NavigationService navigationService = Modular.get<NavigationService>();
    print("session $session");
    if (session == null || session == "") {
      navigationService.navigateTo('/authenticate');
    } else {
      navigationService.navigateTo('/posts');
    }
  }

}


class InitModule extends MainModule {

  @override
  List<Bind> get binds => [
    Bind((_) => NavigationService()),
  ];

  @override
  List<Router> get routers => [];

  Widget get bootstrap => ZeusApp();
}

