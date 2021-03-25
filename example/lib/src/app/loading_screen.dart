import 'package:flutter/foundation.dart';
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
    final routingState = context.read(appRoutingState);
    final app = MaterialApp.router(
      routerDelegate: RouterDelegateAdapter<AppRoutingState>(
        LoadingRouterDelegate(
          loadingState,
          loaded: App(),
          loadingIndicator: CircularProgressIndicator(),
          background: Container(color: Colors.amber),
        ),
        () => AppRoutingState(loadingState.value, routingState.currentRoute),
        [
          (state) => loadingState.value = state.dataLoadingState,
          (state) => routingState.currentRoute = state.routingState,
        ],
        [
          loadingState,
          routingState,
        ],
      ),
      routeInformationParser: AppRouteInformationParser(),
      routeInformationProvider: PlatformRouteInformationProvider(
          initialRouteInformation: initialRouteInformation),
      title: 'Routing Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
    return app;
  }
}

class AppRouteInformationParser
    implements RouteInformationParser<AppRoutingState> {
  @override
  Future<AppRoutingState> parseRouteInformation(
      RouteInformation routeInformation) {
    final state = routeInformation.state;
    late final DataLoadingState loadingState;
    if (state is int && state >= 0 && state < DataLoadingState.values.length) {
      loadingState = DataLoadingState.values.elementAt(state);
    } else {
      loadingState = DataLoadingState.loaded;
    }
    return SynchronousFuture(AppRoutingState(
      loadingState,
      AppRoute.fromPath(routeInformation.location ?? 'default_route'),
    ));
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoutingState configuration) {
    return RouteInformation(
      location: configuration.routingState.path,
      state: configuration.dataLoadingState.index,
    );
  }
}
