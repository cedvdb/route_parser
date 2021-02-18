import 'package:route_parser/route_parser.dart';

void main() {
  // match
  final m1 = RouteParser('/route').parse('/route');
  final m2 = RouteParser('/route/*').parse('/route/any');
  final m3 = RouteParser('/route/**').parse('/route/any/with/look/ahead');
  final m4 =
      RouteParser('/route/:param').parse('/route/100'); // match with args
  final m5 = RouteParser('/test/withargs/:id/wildcards/*/forward/**')
      .parse('/test/withargs/100/wildcards/any/forward/any/thing/else/after');

  print([m1, m2, m3, m4, m5].every((m) => m.matches));
  print(m4.parameters['param'] == '100');
}
