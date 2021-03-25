import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:route_kit/route_kit.dart';

import 'app_bottom_nav_bar.dart';
import 'state.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routingUi = context.read(appRoutingUi);
    return Scaffold(
      appBar: AppNavBar(),
      body: makeAppRouter(context, routingUi),
      bottomNavigationBar: AppBottomNavBar(),
    );
  }
}

class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: BackButton(
        onPressed: () {
          print('maybePop');
          // Navigator.maybePop(context);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
