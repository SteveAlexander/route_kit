import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:route_kit/route_kit.dart';

import 'app_tab.dart';

final appRoutingState =
    ChangeNotifierProvider<RoutingState>((_) => throw UnimplementedError());

final appRoutingUi =
    ChangeNotifierProvider<RoutingUi<AppTab>>((_) => throw UnimplementedError());

final dataLoadingState =
    ChangeNotifierProvider<ValueNotifier<DataLoadingState>>((_) => throw UnimplementedError());

class AppRoutingState {
  final DataLoadingState dataLoadingState;
  final AppRoute routingState;
  AppRoutingState(this.dataLoadingState, this.routingState);
}
