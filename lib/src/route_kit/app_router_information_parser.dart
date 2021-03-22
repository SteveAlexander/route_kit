import 'package:flutter/widgets.dart';

import 'app_route.dart';
import 'routing_state.dart';

class AppRouterInformationParser extends RouteInformationParser<AppRoute> {
  RoutingState routingState;
  AppRouterInformationParser(this.routingState);

  @override
  Future<AppRoute> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? '');
    final segments = uri.pathSegments;
    if (segments.isEmpty) {
      // print('AppRouterInformationParser: init ${routingState.initialRoute.path}');
      return routingState.initialRoute;
    }
    // print('AppRouterInformationParser: ${routingState.fromSegments(segments).path}');
    return routingState.fromSegments(segments);
  }

  @override
  RouteInformation restoreRouteInformation(AppRoute configuration) {
    // print('restoreRouteInformation(${configuration.path})');
    return RouteInformation(location: configuration.path);
  }
}
