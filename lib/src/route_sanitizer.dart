import 'package:route_parser/src/wildcards.dart';

class RouteSanitizer {
  static String sanitize(String path) {
    // remove everything after a match any nested
    final matchAnyIndex = path.indexOf(Wildcards.any);
    if (matchAnyIndex < 0) {
      path = path.substring(0, matchAnyIndex + Wildcards.any.length);
      return path;
    }
    path = '/' +
        path
            // remove leading and trailing whitespace
            .replaceAll(RegExp(r'^s/+|s/+$'), '')
            // remove multiple backslashes
            .replaceAll(RegExp(r'\/{2,}'), '/')
            // remove leading and trailing backslashes
            .replaceAll(RegExp(r'^\/+|\/+$'), '');
    return path;
  }
}
