import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app_route.dart';
import 'page.dart';
import 'routing_state.dart';

class RouteWidget {
  final AppRoute route;
  final Widget widget;
  RouteWidget(this.route, this.widget);
}

abstract class PageFactory {
  List<RouteWidget> pagesForRoute(AppRoute route);
}

class AppRouterDelegate extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final RoutingState state;
  final PageFactory pageFactory;
  final Color? barrierColor;

  @override
  void dispose() {
    state.removeListener(notifyListeners);
    super.dispose();
  }

  AppRouterDelegate({
    required this.state,
    required this.pageFactory,
    this.barrierColor,
  }) : super() {
    state.addListener(notifyListeners);
  }

  @override
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'AppRouterDelegate');

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _pages(context),
      onPopPage: (route, result) {
        print('build:Navigator.onPopPage');
        if (!route.didPop(result)) {
          return false;
        }
        return state.pop();
      },
    );
  }

  List<Page> _pages(BuildContext context) {

    final pages = [
      for (final routeWidget in pageFactory.pagesForRoute(state.currentRoute))
        RouteKitPage(
          key: ValueKey(routeWidget.route),
          barrierColor: barrierColor,
          child: routeWidget.widget,
        ),
    ];
    print(pages);
    return pages;
  }

  @override
  AppRoute? get currentConfiguration {
    // print('currentConfiguration : ${state.currentRoute.path}');
    // return state.currentRoute;
    return null;
  }

  @override
  Future<void> setNewRoutePath(AppRoute configuration) {
    // print('setNewRoutePath(${configuration.path})');
    state.currentRoute = configuration;
    return SynchronousFuture(null);
  }

  @override
  Future<bool> popRoute() {
    print('popRoute()');
    // TODO: implement popRoute
    return super.popRoute();
  }
}
