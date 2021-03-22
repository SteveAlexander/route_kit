import 'package:flutter/foundation.dart';

import 'app_route.dart';
import 'exceptions.dart';

class RoutingState extends ChangeNotifier {
  final Map<String, List<String>> _routes = {};
  late final String _initialTab;

  late String _currentTab;

  void addTab(String slug) {
    if (_routes.isEmpty) {
      _currentTab = _initialTab = slug;
    }
    _routes[slug] = [];
  }

  AppRoute get initialRoute => AppRoute(_initialTab, []);

  AppRoute fromSegments(List<String> segments) {
    _validateSegments(segments);
    return AppRoute(segments.first, segments.sublist(1));
  }

  void _validateSegments(List<String> segments) {
    if (segments.isEmpty) {
      throw InvalidRouteException('Empty segments', segments);
    }
    final slug = segments.first;
    if (!_routes.containsKey(slug)) {
      throw InvalidRouteException('first segment is not a known tab', segments);
    }
  }

  AppRoute get currentRoute => AppRoute(_currentTab, _currentSegments);

  set currentRoute(AppRoute route) {
    _validateSegments(route.segments);
    _currentTab = route.first;
    _routes[_currentTab] = route.segments.sublist(1);
    notifyListeners();
  }

  set currentTabIndex(int index) {
    _currentTab = _routes.keys.elementAt(index);
    notifyListeners();
  }

  int get currentTabIndex => _routes.keys.toList().indexOf(_currentTab);

  List<String> get _currentSegments => _routes[_currentTab]!;

  bool pop() {
    print('pop!');
    if (_currentSegments.isEmpty) {
      return false;
    }
    _currentSegments.removeLast();
    notifyListeners();
    return true;
  }
}
