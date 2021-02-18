import 'package:route_parser/route_parser.dart';
import 'package:route_parser/src/match_type.dart';
import 'package:test/test.dart';

import 'matchers.dart';

void main() {
  group('Route', () {
    test('should match exact route', () {
      final path = '/test/route';
      expect(RouteParser(path).parse(path), isMatch());
      expect(RouteParser(path).parse('/'), isNotMatch());
      expect(RouteParser(path).parse('/test/route/longer'), isNotMatch());
      expect(RouteParser(path).parse('/not/same'), isNotMatch());
      expect(RouteParser('/').parse('/not'), isNotMatch());
    });

    test('should match exact route with typos', () {
      expect(RouteParser('/test/route').parse('test/route'), isMatch());
      expect(RouteParser('/test/route').parse('test/route/'), isMatch());
      expect(RouteParser('/test/route').parse(' /test/route/  '), isMatch());
      expect(RouteParser('test/route').parse('//test/route /'), isMatch());
    });

    test('should match partially', () {
      final path = '/test/route';

      expect(
        RouteParser('/').parse('/any/route', MatchType.partial),
        isMatch(),
      );

      expect(
        RouteParser(path).parse('/test/route', MatchType.partial),
        isMatch(),
      );
      expect(
        RouteParser(path).parse('/test/route/more', MatchType.partial),
        isMatch(),
      );
      expect(
        RouteParser(path).parse('/another/route', MatchType.partial),
        isNotMatch(),
      );
      expect(
        RouteParser(path).parse('/', MatchType.partial),
        isNotMatch(),
      );
      expect(
        RouteParser(path).parse('/test', MatchType.partial),
        isNotMatch(),
      );
      expect(
        RouteParser(path).parse('test/another', MatchType.partial),
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

    test('should do all 3 at the same time', () {
      final path = '/teams/:teamId/*/route/**';
      final match = RouteParser(path).parse('/teams/100/any/route/any/ahead');
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
