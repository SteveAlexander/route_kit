import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data_loading_state.dart';
import 'no_animation_transition_delegate.dart';
import 'transparent_page.dart';

class LoadingRouterDelegate extends RouterDelegate<DataLoadingState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final StateController<DataLoadingState> _state;
  late RemoveListener _removeListener;
  final Widget loaded;
  final Widget background;
  final Widget loadingIndicator;

  LoadingRouterDelegate(
    this._state, {
    required this.loaded,
    required this.background,
    required this.loadingIndicator,
  }) {
    _removeListener = _state.addListener((_) => notifyListeners());
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  Future<bool> popRoute() {
    print('LoadingRouterDelegate.popRoute()');
    // TODO: implement popRoute
    return super.popRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _pages(context),
      transitionDelegate: NoAnimationTransitionDelegate(),
      onPopPage: (route, result) {
        print('Loading Navigator.onPopPage');
        // if (!route.didPop(result)) {
        //   return false;
        // }

        // Not allowed to pop the main app
        return false;
      },
    );
  }

  List<Page> _pages(BuildContext context) {
    final state = _state.state;
    if (state == DataLoadingState.loaded) {
      return [
        MaterialPage(
          key: ValueKey(DataLoadingState.loaded),
          child: Material(child: loaded),
        )
      ];
    }
    return [
      MaterialPage(
        key: ValueKey('background'),
        child: background,
      ),
      if (state == DataLoadingState.loading)
        TransparentPage(
          key: ValueKey(DataLoadingState.loading),
          child: Container(
            alignment: Alignment.center,
            child: loadingIndicator,
          ),
        ),
    ];
  }

  @override
  final GlobalKey<NavigatorState>? navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'Loader');

  @override
  DataLoadingState? get currentConfiguration {
    // print('LoadingRouterDelegate.currentConfiguration: ${_state.state}');
    return _state.state;
  }

  @override
  Future<void> setNewRoutePath(DataLoadingState configuration) {
    // _state.state = configuration;
    // print('LoadingRouterDelegate.setNewRoutePath($configuration)');
    return SynchronousFuture(null);
  }
}
