class AppRoute {
  final List<String> segments;

  AppRoute(String tab, List<String> segments)
      : segments = List.unmodifiable([tab, ...segments]);

  AppRoute.fromPath(String path)
      : segments = List.unmodifiable(path.split('/'));

  String get path => segments.join('/');

  String get first => segments.first;

  // AppRoute push(String segment) {
  //   return AppRoute([...segments, segment]);
  // }

  // AppRoute pop() {
  //   return segments.length == 1
  //       ? this
  //       : AppRoute(segments.sublist(0, segments.length - 1));
  // }

  @override
  bool operator ==(Object? other) {
    return other is AppRoute && other.segments == segments;
  }

  @override
  int get hashCode => segments.hashCode;

  @override
  String toString() => 'AppRoute($path)';
}
