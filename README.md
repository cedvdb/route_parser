# Route Parser

A route parsing package.

Originally created by @lukepighetti for fluro 2.0.

## Usage


```dart
import 'package:route_parser/route_parser.dart';

// match 
RouteParser('/route').match('/route');
RouteParser('/route/*').match('/route/any');
RouteParser('/route/**').match('/route/any/with/look/ahead');
RouteParser('/route/:args').match('/route/100'); // match with args
final parser = RouteParser('/test/withargs/:id/wildcards/*/forward/**');
parser.match('/test/withargs/100/wildcards/any/forward/any/thing/else/after'); // match with param 100
```

## Wildcards

  - * any for a specific segment
  - ** any look ahead
  - : gets param

[tracker]: http://example.com/issues/replaceme
