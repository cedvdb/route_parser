import 'parsing_result.dart';
import 'match_type.dart';

/// Representation of a route that can then be parsed and matched against other types
class RouteParser {
  final Uri _uri;

  List<String> get segments => _uri.pathSegments;

  RouteParser(String path) : _uri = Uri(path: sanitize(path));

  /// matches a path against this route.
  bool match(String path, [MatchType matchType = MatchType.full]) {
    return parse(path, matchType).matches;
  }

  /// parses path against this route
  ParsingResult parse(String path, [MatchType matchType = MatchType.full]) {
    final toMatch = RouteParser(path);
    final matches = <bool>[];
    final params = <String, String>{};
    // if toMatch is shorter it's defacto not a full match
    final toMatchIsShorter = toMatch.segments.length < segments.length;
    // if toMatch is longer and the matchType is partial, it could it still be matching
    final toMatchIsLonger = toMatch.segments.length > segments.length;
    final getResult = () => ParsingResult(
          matches: matches.every((m) => m),
          pathParameters: params,
          path: path,
          patternPath: _uri.path,
        );

    if (toMatchIsShorter) {
      matches.add(false);
      return getResult();
    }

    for (var i = 0; i < segments.length; i++) {
      final patternSegment = segments[i];
      final toMatchSegment = toMatch.segments[i];
      final isLastPatternSegment = i == segments.length - 1;

      // we checked for the match any_forward wildcard, at this point if
      // toMatch is longer, it is no longer a match
      if (isLastPatternSegment && toMatchIsLonger) {
        if (matchType == MatchType.partial) {
          matches.add(true);
        } else {
          matches.add(false);
        }
        return getResult();
      }

      // we extract the param
      if (patternSegment.startsWith(':')) {
        final key = patternSegment.replaceFirst(':', '');
        params[key] = toMatchSegment;
        matches.add(true);
        continue;
      }

      // Exact segment match
      if (toMatchSegment == patternSegment) {
        matches.add(true);
        continue;
      } else {
        matches.add(false);
        return getResult();
      }
    }

    return getResult();
  }

  /// sanitize path by removing leading and trailing spaces and backslashes
  static String sanitize(String path) {
    path = '/' +
        path
            .replaceAll(RegExp(r'^\s+|\s+$'), '')
            .replaceAll(RegExp(r'^\/+|\/+$'), '');
  }
}
