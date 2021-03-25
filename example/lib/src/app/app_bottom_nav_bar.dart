import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'state.dart';

class AppBottomNavBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final routingUi = watch(appRoutingUi);
    
    return BottomNavigationBar(
      onTap: (index) => context.read(appRoutingUi).currentTabIndex = index,
      currentIndex: routingUi.currentTabIndex,
      items: [
        for (final tab in routingUi.tabs)
          BottomNavigationBarItem(
            icon: Icon(tab.iconData),
            label: tab.label,
          ),
      ],
    );
  }
}
