import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

typedef RoutingStateAccess<G> = G Function();

typedef RoutingStateSetter<G> = void Function(G generalState);

class RouterDelegateAdapter<G> extends ChangeNotifier implements RouterDelegate<G> {
  // maybe doesn't need to be a ChangeNotifier
  final RouterDelegate _delegate;
  final RoutingStateAccess<G> _routingStateAccess;
  final List<RoutingStateSetter<G>> _routingStateSetters;
  final List<Listenable> _listenables;

  RouterDelegateAdapter(
    this._delegate,
    this._routingStateAccess,
    this._routingStateSetters,
    this._listenables,
  ) {
    for (final listenable in _listenables) {
      listenable.addListener(_listener);
    }
  }

  void _listener() {
    print('listener!');
    notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _delegate.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {

    /*
        options:
        1. somehow Router.navigate() to make it get the root router's currentConfigration
        2. directly call root router's RIProvider.routerReportsNewRouteInformation(routeInformation)
        3. plan A to wrap each router and have each router report the full app state

    */
    return _delegate.build(context);
  }

  @override
  G? get currentConfiguration {
    // At most one [Router] can opt in to route information reporting.
    // Typically, only the top-most [Router] created by [WidgetsApp.router]
    // should opt for route information reporting.

    // So, in the topmost router, we need to know the total state of the app
    // and be able to construct it from the individual states
    // Other routers return null for this
    print('currentConfiguration!');
    return _routingStateAccess();
  }

  @override
  Future<bool> popRoute() {
    return _delegate.popRoute();
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    _delegate.removeListener(listener);
  }

  @override
  void dispose() {
    for (final listenable in _listenables) {
      listenable.removeListener(_listener);
    }
    super.dispose();
  }

  @override
  Future<void> setInitialRoutePath(G configuration) {
    // Called by the [Router] at startup with the structure that the
    // [RouteInformationParser] obtained from parsing the initial route.
    //
    // This should configure the [RouterDelegate] so that when [build] is
    // invoked, it will create a widget tree that matches the initial route.
    //
    // By default, this method forwards the [configuration] to [setNewRoutePath].

    // return _delegate.setInitialRoutePath(_generalToSpecific(configuration));
    Future.microtask(() {
      for (final stateSetter in _routingStateSetters) {
        stateSetter(configuration);
      }
      notifyListeners();
    });
    return SynchronousFuture(null);
    // return setNewRoutePath(configuration);
  }

  @override
  Future<void> setNewRoutePath(G configuration) {
    // Called by the [Router] when the [Router.routeInformationProvider]
    // reports that a new route has been pushed to the application by
    // the operating system.

    /**
     * Forwarding this to the router, and the router sets the state
     * So, we'd need to forward this to each router we're wrapping
     * with the _generalToSpecific() logic to extract the state
     * 
     * OR, directly update all the states here
     * 
     * Advantage of the former — each router has a reference to a RIProvider that
     * is setting new route paths, and we're extracting the relevant specific
     * part from that.
     * 
     * Advantage of the latter — we deal with the state at the top level,
     * and non top level routers become simpler, as they don't need to
     * listen to the OS state via a RIProvider, and they don't need wrapping.
     * They just need their delegate and back button handler.
     * 
     * The latter seems to be the way to do it. In which case, here we need
     * to alter the state of each router based on the configuration.
     */

    // return _delegate.setNewRoutePath(_generalToSpecific(configuration));
    // Future.microtask(() {
      for (final stateSetter in _routingStateSetters) {
        stateSetter(configuration);
      }
    // });
    notifyListeners();
    return SynchronousFuture(null);
  }
}
