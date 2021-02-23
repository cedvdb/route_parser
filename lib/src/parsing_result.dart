/// The result of trying to match a path to a route.
class ParsingResult {
  ParsingResult({
    required this.matches,
    required this.path,
    required this.patternPath,
    required this.matchingPath,
    required this.pathParameters,
  });

  /// The route path that was matched
  ///
  /// ie `/route/123`
  final String path;

  /// The part of the route
  ///
  /// ie `/route` when the path is `/route/123` and the route pattern is `/route/:id`
  final String matchingPath;

  /// The route path being matched onto
  ///
  /// ie `/route/:id`
  final String patternPath;

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
    return 'ParsingResult(path: $path, pattern: $patternPath, matches: $matches, pathParameters: $pathParameters)';
  }
}
