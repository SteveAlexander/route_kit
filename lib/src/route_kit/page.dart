import 'package:flutter/widgets.dart';

class RouteKitPage extends Page {
  final Widget child;
  final Color? barrierColor;

  RouteKitPage({
    LocalKey? key,
    this.barrierColor,
    required this.child,
  }) : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      opaque: true,
      barrierColor: this.barrierColor,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
