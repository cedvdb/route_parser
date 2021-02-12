import 'package:test/test.dart';

class isMatch extends Matcher {
  const isMatch();
  @override
  bool matches(item, Map matchState) => item.matches == true;
  @override
  Description describe(Description description) => description.add('a match');
}

class isNotMatch extends Matcher {
  const isNotMatch();
  @override
  bool matches(item, Map matchState) => item.matches == false;
  @override
  Description describe(Description description) =>
      description.add('not a match');
}
