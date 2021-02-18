/// specify how the match should be matched on
enum MatchType {
  /// a full match must match exactly the pattern
  full,

  /// in a partial match the route being matched *can* be longer
  ///
  /// RouteParser('/route') will match '/route' and '/route/any'
  partial,
}
