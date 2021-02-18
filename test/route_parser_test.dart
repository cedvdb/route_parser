import 'package:route_parser/route_parser.dart';
import 'package:test/test.dart';

import 'matchers.dart';

void main() {
  group('Route', () {
    test('should match exact route', () {
      final path = '/test/route';
      expect(RouteParser(path).match(path), isMatch());
      expect(RouteParser(path).match('/not/same'), isNotMatch());
    });

    test('should match exact route with typos', () {
      expect(RouteParser('/test/route').match('test/route'), isMatch());
      expect(RouteParser('/test/route').match('test/route/'), isMatch());
      expect(RouteParser('/test/route').match(' /test/route/  '), isMatch());
      expect(RouteParser('test/route').match('//test/route /'), isMatch());
    });

    test('should match wildcard *', () {
      final path = '/test/*';
      expect(RouteParser(path).match('/test/route'), isMatch());
      expect(RouteParser(path).match('test/another'), isMatch());
      expect(RouteParser(path).match('/another/route'), isNotMatch());
      expect(RouteParser(path).match('/test'), isNotMatch());
      expect(RouteParser(path).match('/test/route/route'), isNotMatch());
    });

    test('should match wildcard **', () {
      final path = '/test/**';
      expect(RouteParser(path).match('/test/route'), isMatch());
      expect(RouteParser(path).match('test/another'), isMatch());
      expect(RouteParser(path).match('/test/route/another'), isMatch());
      expect(RouteParser(path).match('/test/route/another/another'), isMatch());
      expect(RouteParser(path).match('/test'), isNotMatch());
    });

    test('should get arguments', () {
      final path = '/teams/:teamId/users/:userId';
      final params = RouteParser(path).match('/teams/x/users/y').parameters;
      expect(params['teamId'], equals('x'));
      expect(params['userId'], equals('y'));
      expect(params.length, equals(2));
    });

    test('should do all 3 at the same time', () {
      final path = '/teams/:teamId/*/route/**';
      final match = RouteParser(path).match('/teams/100/any/route/any/ahead');
      expect(match.matches, isTrue);
      expect(match.parameters['teamId'], equals('100'));
    });

    test('should format silly paths to prevent typos', () {
      final path = '/test/route';
      final path2 = '/test/**';
      expect(RouteParser.sanitize('test/route'), equals(path));
      expect(RouteParser.sanitize('test/route/'), equals(path));
      expect(RouteParser.sanitize('/test/route/'), equals(path));
      expect(RouteParser.sanitize('////test///route///'), equals(path));
      expect(RouteParser.sanitize('  / test / route'), equals(path));
      expect(RouteParser.sanitize('test/route'), equals(path));
      expect(RouteParser.sanitize('   test  /  route   /  '), equals(path));
      expect(RouteParser.sanitize('/test/route/'), equals(path));
      expect(RouteParser.sanitize('// / / test / //route///'), equals(path));
      expect(RouteParser.sanitize('/not/route'), isNot(path));
      expect(RouteParser.sanitize('/   not  / route'), isNot(path));

      expect(RouteParser.sanitize('/test/**/something/meaningless'),
          equals(path2));
    });
  });
}
