import 'package:flutter/widgets.dart';

import 'routing_state.dart';

typedef WidgetFactory0 = Widget Function();
typedef WidgetFactory1 = Widget Function(String a);
typedef WidgetFactory2 = Widget Function(String a, String b);
typedef WidgetFactory3 = Widget Function(String a, String b, String c);

typedef WidgetFactory = Widget Function([String? a, String? b, String? c]);

class MatchingRoute {
  Match match;
  WidgetFactory widgetFactory;
  int get matchLength => match.end;
  String get matchString => match.input.substring(0, matchLength);

  MatchingRoute(this.match, this.widgetFactory);

  Widget call() {
    switch (match.groupCount) {
      case 0:
        return widgetFactory();
      case 1:
        return widgetFactory(match.group(1)!);
      case 2:
        return widgetFactory(match.group(1)!, match.group(2)!);
      case 3:
        return widgetFactory(match.group(1)!, match.group(2)!, match.group(3)!);
      default:
        throw WrongNumberOfMatchGroupsForWidgetFactory(
            match.pattern.toString());
    }
  }
}

class RoutingUi<T> {
  final RoutingState state;

  final Map<RegExp, WidgetFactory> _routes = {};
  final Map<String, T> _tabs = {};

  List<T> get tabs => [..._tabs.values];

  RoutingUi(this.state);

  List<MapEntry<String, Widget>> match(String input) {
    Match? match;
    final matchingRoutes = [
      for (final entry in _routes.entries)
        if ((match = entry.key.matchAsPrefix(input)) != null)
          MatchingRoute(match!, entry.value)
    ];

    if (matchingRoutes.isEmpty) {
      throw UnmatchedRoute(input);
    }

    final routesShortFirst = matchingRoutes
      ..sort((a, b) => a.matchLength.compareTo(b.matchLength));
    if (routesShortFirst.last.matchLength < input.length) {
      throw UnmatchedRoute(input);
    }
    return [
      for (final route in routesShortFirst)
        MapEntry(route.matchString, route()),
    ];
  }

  void addTab(String slug, T appTab) {
    state.addTab(slug);
    _tabs[slug] = appTab;
  }

  RegExp _asRegExp(String pattern) => RegExp('^$pattern');

  void addRoute0(String pattern, WidgetFactory0 factory) {
    _routes[_asRegExp(pattern)] = ([a, b, c]) => factory();
  }

  void addRoute1(String pattern, WidgetFactory1 factory) {
    _routes[_asRegExp(pattern)] = ([a, b, c]) => factory(a!);
  }

  void addRoute2(String pattern, WidgetFactory2 factory) {
    _routes[_asRegExp(pattern)] = ([a, b, c]) => factory(a!, b!);
  }

  void addRoute3(String pattern, WidgetFactory3 factory) {
    _routes[_asRegExp(pattern)] = ([a, b, c]) => factory(a!, b!, c!);
  }
}

class UnmatchedRoute implements Exception {
  final String offered;

  UnmatchedRoute(this.offered);

  @override
  String toString() => 'UnmatchedRoute($offered)';
}

class WrongNumberOfMatchGroupsForWidgetFactory implements Exception {
  final String pattern;

  WrongNumberOfMatchGroupsForWidgetFactory(this.pattern);

  @override
  String toString() => 'WrongNumberOfMatchGroupsForWidgetFactory($pattern)';
}
