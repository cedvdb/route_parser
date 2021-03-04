import 'parsing_result.dart';
import 'dart:math';

/// Representation of a route that can then be parsed and matched against other types
class RouteParser {
  final Uri _uri;

  List<String> get segments => _uri.pathSegments;

  RouteParser(String path) : _uri = Uri(path: sanitize(path));

  /// matches a path against this route.
  bool match(String path, {bool matchChildren = false}) {
    return parse(path, matchChildren: matchChildren).matches;
  }

  /// adds params to a route
  String reverse(Map<String, String> params) {
    final segments = _uri.pathSegments.map((segment) {
      if (segment.startsWith(':')) {
        final key = segment.replaceFirst(':', '');
        final param = params[key];
        if (param != null) {
          return param;
        }
      }
      return segment;
    });
    return '/' + segments.join('/');
  }

  /// parses path against this route
  ParsingResult parse(String path, {bool matchChildren = false}) {
    final toMatch = RouteParser(path);
    final matches = <bool>[];
    final params = <String, String>{};
    final matchingSegments = [];
    final toMatchIsShorter = toMatch.segments.length < segments.length;
    final toMatchIsLonger = toMatch.segments.length > segments.length;
    final minLength = min(segments.length, toMatch.segments.length);

    // if toMatch is shorter it's defacto not a match
    if (toMatchIsShorter) {
      matches.add(false);
    }

    // if toMatch is longer and we can match children, it could it still be matching
    if (matchChildren == false && toMatchIsLonger) {
      matches.add(false);
    }

    for (var i = 0; i < minLength; i++) {
      final patternSegment = segments[i];
      final toMatchSegment = toMatch.segments[i];

      // we extract the param
      if (patternSegment.startsWith(':')) {
        final key = patternSegment.replaceFirst(':', '');
        params[key] = toMatchSegment;
        matchingSegments.add(toMatchSegment);
        matches.add(true);
        continue;
      }

      // Exact segment match
      if (toMatchSegment == patternSegment) {
        matches.add(true);
        matchingSegments.add(toMatchSegment);
        continue;
      } else {
        matches.add(false);
        break;
      }
    }

    return ParsingResult(
      matches: matches.every((m) => m),
      pathParameters: params,
      path: path,
      patternPath: _uri.path,
      matchingPath: '/' + matchingSegments.join('/'),
    );
  }

  /// sanitize path by removing leading and trailing spaces and backslashes
  static String sanitize(String path) {
    return '/' +
        path
            .replaceAll(RegExp(r'^\s+|\s+$'), '')
            .replaceAll(RegExp(r'^\/+|\/+$'), '');
  }
}
