import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:git_demo/routes/HomeRoute.dart';

class RouteName {
  static const String splash = 'splash';
  static const String home = 'home';
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splash:
        return CupertinoPageRoute(
            builder: (_) =>
                Scaffold(
                  appBar: AppBar(
                    title: new Text('splash'),
                  ),
                  body: Center(
                    child: Text('route:${settings.name}'),
                  ),
                ));
      case RouteName.home:
        return CupertinoPageRoute(builder: (_) => HomeRoute());
      default:
        return CupertinoPageRoute(
            builder: (_) =>
                Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}

/// Pop路由
class PopRoute extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  PopRoute({@required this.child});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}
