# Route Parser

A route parsing dart package.

Originally created by @lukepighetti for fluro 2.0, it has now been modified subtantially.

## Usage


```dart
import 'package:route_parser/route_parser.dart';

// match 
RouteParser('/route').match('/route'); // true
RouteParser('/route', MatchType.partial).match('/route'); // true
RouteParser('/route').match('/route/any'); // false
RouteParser('/route', MatchType.partial).match('/route/any/with/look/ahead'); //true
RouteParser('/route/:id').parse('/route/100'); // match true with params['id'] = 100
```

