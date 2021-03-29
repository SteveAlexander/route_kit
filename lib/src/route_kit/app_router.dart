import 'package:flutter/widgets.dart';

import 'app_route.dart';
import 'app_router_delegate.dart';
// import 'app_router_information_parser.dart';
import 'routing_ui.dart';

class DelegatedRouteInformationProvider implements RouteInformationProvider {
  final RouteInformationProvider _parent;

  DelegatedRouteInformationProvider(this._parent);

  @override
  void addListener(VoidCallback listener) {
    _parent.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _parent.removeListener(listener);
  }

  @override
  void routerReportsNewRouteInformation(RouteInformation routeInformation) {
    _parent.routerReportsNewRouteInformation(routeInformation);
  }

  @override
  RouteInformation? get value => _parent.value;
}

Router makeAppRouter({
  required BuildContext context,
  required RoutingUi routingUi,
  Color? barrierColor,
}) {
  final routingState = routingUi.state;
  return Router(
    // routeInformationParser: AppRouterInformationParser(routingState),
    // routeInformationProvider: DelegatedRouteInformationProvider(
    //     Router.of(context).routeInformationProvider!),
    // routeInformationProvider: Router.of(context).routeInformationProvider,
    backButtonDispatcher: Router.of(context)
        .backButtonDispatcher!
        .createChildBackButtonDispatcher()
          ..takePriority(),
    routerDelegate: AppRouterDelegate(
      barrierColor: barrierColor,
      state: routingState,
      pageFactory: RoutingUiPageFactory(routingUi),
    ),
  );
}

class RoutingUiPageFactory implements PageFactory {
  final RoutingUi _routingUi;

  RoutingUiPageFactory(this._routingUi);

  @override
  List<RouteWidget> pagesForRoute(AppRoute route) {
    return [
      for (final entry in _routingUi.match(route.path))
        RouteWidget(AppRoute.fromPath(entry.key), entry.value)
    ];
  }
}
