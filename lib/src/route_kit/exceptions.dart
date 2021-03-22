class InvalidRouteException implements Exception {
  final String message;
  final List<String> segments;
  InvalidRouteException(this.message, this.segments);

  @override
  String toString() =>
      '${runtimeType.toString()}($message, ${segments.join('/')})';
}
