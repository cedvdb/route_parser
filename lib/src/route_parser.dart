import 'route_formatter.dart';
import 'route_match.dart';
import 'wildcards.dart';

/// Representation of a route:
/// /route/example matches only /route/example
/// /route/* matches /route/anything but not /route/anything/other
/// /route/** matches /route/any/number/of/segments
class RouteParser {
  final Uri _uri;

  List<String> get segments => _uri.pathSegments;

  RouteParser(String path) : _uri = Uri(path: format(path));

  static String format(String path) {
    return RouteFormatter.format(path);
  }

  /// matches a path against this route.
  RouteMatch match(String path) {
    final toMatch = RouteParser(path);
    final matches = <bool>[];
    final params = <String, String>{};
    // if toMatch is shorter it's defacto not a full match
    final toMatchIsShorter = toMatch.segments.length < segments.length;
    // if toMatch is longer the wild card any_forward could make it still be matching
    final toMatchIsLonger = toMatch.segments.length > segments.length;

    for (var i = 0; i < segments.length; i++) {
      final segment = _uri.pathSegments[i];
      final toMatchSegment = toMatch.segments[i];
      final isLastSegment = i == segments.length - 1;

      // if toMatch is shorter it's defacto not a full match
      if (toMatchIsShorter) {
        matches.add(false);
        break;
      }

      // if we reach a match any nested wildcard then whatever is after
      // is going to be matching and what is before has been checked
      if (segment == Wildcards.any_forward) {
        matches.add(true);
        break;
      }

      // we checked for the match any_forward wildcard, at this point if
      // toMatch is longer, it is no longer a match
      if (isLastSegment && toMatchIsLonger) {
        matches.add(false);
        break;
      }

      if (segment == Wildcards.any) {
        matches.add(true);
        // check next segment
        continue;
      }

      // we extract the param
      if (segment.startsWith(Wildcards.param)) {
        final key = segment.replaceFirst(':', '');
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
        break;
      }
    }

    return RouteMatch(
      matches: matches.every((m) => m),
      pathParameters: params,
      path: path,
      route: _uri.path,
    );
  }
}
