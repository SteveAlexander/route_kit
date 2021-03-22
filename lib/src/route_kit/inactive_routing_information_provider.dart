import 'package:flutter/widgets.dart';

class InactiveRouteInformationProvider implements RouteInformationProvider {
  @override
  void addListener(VoidCallback listener) {
    // do nothing
  }

  @override
  void removeListener(VoidCallback listener) {
    // do nothing
  }

  @override
  void routerReportsNewRouteInformation(RouteInformation routeInformation) {
    // do nothing
  }

  @override
  RouteInformation? get value => RouteInformation(location: null);
}
