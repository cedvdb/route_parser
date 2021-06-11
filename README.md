# Route Parser

A route parsing dart package.

## Usage


```dart
import 'package:route_parser/route_parser.dart';

// parse
RouteParser('/route/:id').parse('/route/100'); // match true with params['id'] = 100
// match 
RouteParser('/route').match('/route'); // true
RouteParser('/route').match('/route', matchChildren: true); // true
RouteParser('/route').match('/route/any'); // false
RouteParser('/route').match('/route/any', matchChildren: true); //true
```

