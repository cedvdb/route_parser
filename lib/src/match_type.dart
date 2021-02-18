/// specify how the match should be matched on
enum MatchType {
  /// a full match must match exactly the pattern
  full,

  /// in a partial match the url being matched *can* be longer, but the matching pattern
  /// will be exactly as is in the path
  partial,
}
