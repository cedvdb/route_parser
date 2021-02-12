/// The result of trying to match a path to a route.
class RouteMatch {
  RouteMatch({
    required this.matches,
    required this.pathParameters,
    required this.route,
    required this.path,
  });

  /// Used if a route match wasn't found in a list of routes.
  RouteMatch.notFound({required String path})
      : matches = false,
        pathParameters = const {},
        path = path,
        route = '';

  /// The route being referenced
  final String route;

  /// The path being routed
  final String path;

  /// If the [path] matches the [route]
  final bool matches;

  /// The parameters extracted from route wildcards
  ///
  /// ie `{'foo': 'hey'}` from `/route/:foo => /route/hey`
  final Map<String, String> pathParameters;

  /// The query parameters from route query
  ///
  /// ie `{'foo': 'hey'}` from `/route?foo=hey`
  late final Map<String, String> queryParameters =
      Uri.parse(path).queryParameters;

  /// The query parameters from [pathParameters] and [queryParameters]
  ///
  /// Priority will be given to path parameters if there is a key collision.
  late final Map<String, String> parameters = {
    ...queryParameters,
    ...pathParameters
  };

  @override
  String toString() {
    return 'RouteMatch( matches: $matches, route: $route, path: $path, pathParameters: $pathParameters)';
  }
}
