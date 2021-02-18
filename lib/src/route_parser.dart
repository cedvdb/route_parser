import 'route_sanitizer.dart';
import 'route_match.dart';
import 'wildcards.dart';

/// Representation of a route:
/// /route/example matches only /route/example
/// /route/* matches /route/anything but not /route/anything/other
/// /route/** matches /route/any/number/of/segments
class RouteParser {
  final Uri _uri;

  List<String> get segments => _uri.pathSegments;

  RouteParser(String path) : _uri = Uri(path: sanitize(path));

  static String sanitize(String path) {
    return RouteSanitizer.sanitize(path);
  }

  /// matches a path against this route.
  RouteMatch match(String path) {
    final toMatch = RouteParser(path);
    final matches = <bool>[];
    final params = <String, String>{};
    final toMatchIsShorter = toMatch.segments.length < segments.length;
    final toMatchIsLonger = toMatch.segments.length > segments.length;
    final getResult = () => RouteMatch(
          matches: matches.every((m) => m),
          pathParameters: params,
          path: path,
          route: _uri.path,
        );

    // if toMatch is shorter it's defacto not a full match
    if (toMatchIsShorter) {
      matches.add(false);
      return getResult();
    }

    for (var i = 0; i < segments.length; i++) {
      final segment = _uri.pathSegments[i];
      final toMatchSegment = toMatch.segments[i];
      final isLastSegment = i == segments.length - 1;

      // if we reach a match any nested wildcard then whatever is after
      // is going to be matching and what is before has been checked
      if (segment == Wildcards.any) {
        matches.add(true);
        return getResult();
      }

      // we checked for the match any_forward wildcard, at this point if
      // toMatch is longer, it is no longer a match
      if (isLastSegment && toMatchIsLonger) {
        if (toMatch.segments[i + 1] == Wildcards.any) {
          matches.add(true);
          return getResult();
        } else if (toMatch.segments[i + 1] == Wildcards.any_child) {
        } else {
          matches.add(false);
          return getResult();
        }
      }

      // we extract the param
      if (segment.startsWith(Wildcards.param)) {
        final key = segment.replaceFirst(Wildcards.param, '');
        params[key] = toMatchSegment;
        matches.add(true);
        continue;
      }

      /// Exact segment match
      if (toMatchSegment == segment) {
        matches.add(true);
        continue;
      } else {
        matches.add(false);
        return getResult();
      }
    }

    return getResult();
  }
}
