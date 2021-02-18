import 'package:route_parser/src/match_type.dart';

class PathSanitizer {
  static String format(String path) {
    path = '/' +
        path

            /// remove leading and trailing whitespace
            .replaceAll(RegExp(r'^\s+|\s+$'), '')

            /// remove leading and trailing backslashes
            .replaceAll(RegExp(r'^\/+|\/+$'), '');
    return path;
  }
}
