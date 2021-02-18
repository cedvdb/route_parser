# Route Parser

A route parsing dart package.

Originally created by @lukepighetti for fluro 2.0, it has now been modified subtantially.

## Usage


```dart
import 'package:route_parser/route_parser.dart';

// match 
RouteParser('/route').match('/route'); // true
RouteParser('/route').match('/route', MatchType.partial); // true
RouteParser('/route').match('/route/any'); // false
RouteParser('/route').match('/route/any', MatchType.partial); //true
// parse
RouteParser('/route/:id').parse('/route/100'); // match true with params['id'] = 100
```


## MatchTypes

  - `exact`: the path matched cannot be longer
  - `partial`: the path matched can be longer
  
## Note on MatchTypes vs WildCards modification

In version 0.0.1 this package was using wild cards for example `/route/*`.

Since version 0.1.0 the package uses `/route, MatchType.partial` to match.

This is because the expectations for the wildcard seem to differ whether `/route/*` should match `/route` or not.

If a convention is set 