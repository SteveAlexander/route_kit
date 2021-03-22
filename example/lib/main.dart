import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:route_kit/route_kit.dart';

import 'app.dart';

void main() {
  final routingState = RoutingState();
  final routingUi = RoutingUi<AppTab>(routingState)
    ..addTab('home', AppTab('Home', Icons.home_outlined))
    ..addTab('settings', AppTab('Settings', Icons.settings_outlined))
    ..addTab('numbers', AppTab('Add', Icons.plus_one_outlined))
    ..addRoute0('home', () => Center(child: Text('home')))
    ..addRoute1(
        r'numbers/(\d+)', (String arg) => Center(child: Text('number $arg')))
    ..addRoute0('numbers', () => Center(child: Text('numbers page')))
    ..addRoute0('settings', () => Center(child: Text('settings page')));

  final loadingStateController = ValueNotifier(DataLoadingState.unloaded);
  Future.delayed(Duration(seconds: 1), () async {
    loadingStateController.value = DataLoadingState.loading;
    await Future.delayed(Duration(seconds: 3));
    loadingStateController.value = DataLoadingState.loaded;
  });

  runApp(
    ProviderScope(
      overrides: [
        appRoutingState
            .overrideWithProvider(ChangeNotifierProvider((_) => routingState)),
        appRoutingUi.overrideWithValue(routingUi),
        dataLoadingState.overrideWithValue(loadingStateController),
      ],
      child: LoadingRouter(
        initialRouteInformation:
            RouteInformation(location: routingState.initialRoute.path),
      ),
    ),
  );
}
