import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'data_loading_state.dart';

class LoadingRouterInformationParser
    extends RouteInformationParser<DataLoadingState> {

  final RouteInformation? initialRouteInformation;
  LoadingRouterInformationParser({this.initialRouteInformation});

  @override
  Future<DataLoadingState> parseRouteInformation(
      RouteInformation routeInformation) {
    // print(
    //     'LoadingRouterInformationParser.parseRouteInformation($routeInformation)');
    return SynchronousFuture(DataLoadingState.unloaded);
  }

  @override
  RouteInformation? restoreRouteInformation(DataLoadingState configuration) {
    return initialRouteInformation;
  }
}
