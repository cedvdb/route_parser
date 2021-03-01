import 'package:route_parser/route_parser.dart';
import 'package:test/test.dart';

import 'matchers.dart';

void main() {
  group('Route', () {
    test('should match exact route', () {
      final path = '/test/route';
      expect(RouteParser(path).parse(path), isMatch());
      expect(RouteParser('/').parse('/'), isMatch());
      expect(RouteParser(path).parse('/'), isNotMatch());
      expect(RouteParser(path).parse('/test/route/longer'), isNotMatch());
      expect(RouteParser(path).parse('/not/same'), isNotMatch());
      expect(RouteParser('/').parse('/not'), isNotMatch());
    });

    test('should match exact route with typos', () {
      expect(RouteParser('/test/route').parse('test/route'), isMatch());
      expect(RouteParser('/test/route').parse('test/route/'), isMatch());
      expect(RouteParser('/test/route').parse(' /test/route/  '), isMatch());
      expect(RouteParser('test/route').parse(' //test/route/ '), isMatch());
    });

    test('should match partial routes', () {
      final path = '/test/route';

      expect(
        RouteParser('/').parse('/any/route', matchChildren: true),
        isMatch(),
      );

      expect(
        RouteParser(path).parse('test/route', matchChildren: true),
        isMatch(),
      );
      expect(
        RouteParser(path).parse('/test/route/more', matchChildren: true),
        isMatch(),
      );
      expect(
        RouteParser(path).parse('/another/route', matchChildren: true),
        isNotMatch(),
      );
      expect(
        RouteParser(path).parse('/', matchChildren: true),
        isNotMatch(),
      );
      expect(
        RouteParser(path).parse('/test', matchChildren: true),
        isNotMatch(),
      );
      expect(
        RouteParser(path).parse('test/another', matchChildren: true),
        isNotMatch(),
      );
    });

    test('should get arguments', () {
      final path = '/teams/:teamId/users/:userId';
      final params = RouteParser(path).parse('/teams/x/users/y').parameters;
      expect(params['teamId'], equals('x'));
      expect(params['userId'], equals('y'));
      expect(params.length, equals(2));
    });

    test('result should give result of partial match path', () {
      final path = '/teams/:teamId';
      final result =
          RouteParser(path).parse('/teams/x/users/y', matchChildren: true);
      expect(result.path, equals('/teams/x/users/y'));
      expect(result.matchingPath, equals('/teams/x'));
      expect(result.patternPath, equals('/teams/:teamId'));
    });

    test('should format silly paths to prevent typos', () {
      final path = '/test/route';
      expect(RouteParser.sanitize('test/route'), equals(path));
      expect(RouteParser.sanitize('test/route/'), equals(path));
      expect(RouteParser.sanitize(' /test/route/ '), equals(path));
      expect(RouteParser.sanitize('/test/route/'), equals(path));
      expect(RouteParser.sanitize('test/route '), equals(path));
      expect(RouteParser.sanitize('//test/route/'), equals(path));
      expect(RouteParser.sanitize('/not/route'), isNot(path));
      expect(RouteParser.sanitize(' /not/route'), isNot(path));
    });
  });
}
