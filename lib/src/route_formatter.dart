import 'package:route_parser/src/wildcards.dart';

class RouteFormatter {
  static String format(String path) {
    path = '/' +
        path

            /// remove all whitespace
            .replaceAll(RegExp(r'\s'), '')

            /// remove multiple backslashes
            .replaceAll(RegExp(r'\/{2,}'), '/')

            /// remove leading and trailing backslashes
            .replaceAll(RegExp(r'^\/+|\/+$'), '');
    // remove everything after a match any nested
    final matchAllIndex = path.indexOf(Wildcards.any_forward);
    if (matchAllIndex < 0) {
      return path;
    }
    return path.substring(0, matchAllIndex + Wildcards.any_forward.length);
  }
}
