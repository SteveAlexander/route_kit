import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'state.dart';

class AppBottomNavBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final routingUi = watch(appRoutingUi);
    final routingState = watch(appRoutingState);

    return BottomNavigationBar(
      onTap: (index) => context.read(appRoutingState).currentTabIndex = index,
      currentIndex: routingState.currentTabIndex,
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
