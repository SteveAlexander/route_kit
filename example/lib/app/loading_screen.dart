import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:route_kit/route_kit.dart';

import 'app.dart';
import 'state.dart';

class LoadingRouter extends StatelessWidget {
  final RouteInformation? initialRouteInformation;

  LoadingRouter({this.initialRouteInformation});

  @override
  Widget build(BuildContext context) {
    final loadingState = context.read(dataLoadingState);
    return MaterialApp.router(
      routerDelegate: LoadingRouterDelegate(
        loadingState,
        loaded: App(),
        loadingIndicator: CircularProgressIndicator(),
        background: Container(color: Colors.amber),
      ),
      // routeInformationProvider: InactiveRouteInformationProvider(),
      routeInformationParser: LoadingRouterInformationParser(
          initialRouteInformation: initialRouteInformation),
      routeInformationProvider: PlatformRouteInformationProvider(
          initialRouteInformation: initialRouteInformation),
      // backButtonDispatcher: RootBackButtonDispatcher(),
      title: 'Routing Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
