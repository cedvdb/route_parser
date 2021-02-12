import 'package:route_parser/route_parser.dart';

void main() {
  // match
  final m1 = RouteParser('/route').match('/route');
  final m2 = RouteParser('/route/*').match('/route/any');
  final m3 = RouteParser('/route/**').match('/route/any/with/look/ahead');
  final m4 =
      RouteParser('/route/:param').match('/route/100'); // match with args
  final m5 = RouteParser('/test/withargs/:id/wildcards/*/forward/**')
      .match('/test/withargs/100/wildcards/any/forward/any/thing/else/after');

  print([m1, m2, m3, m4, m5].every((m) => m.matches));
  print(m4.parameters['param'] == '100');
}
