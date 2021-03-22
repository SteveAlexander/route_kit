import 'package:flutter/widgets.dart';

class TransparentPage extends Page {
  final Widget child;
  
  TransparentPage({LocalKey? key, required this.child}) : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      opaque: false,
      pageBuilder: (context, _, __) {
        return child;
      },
    );
  }
}
