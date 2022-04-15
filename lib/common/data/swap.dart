extension SwapExtension<T> on List<T> {
  /// Returns a new list where the first two elements
  /// that satisfy the [test] have switched positions.
  ///
  /// If less than two elements satisfy the [test], then
  /// this make no swaps.
  Iterable<T> swapFirstWhere(bool Function(T) test) {
    T? first;
    T? second;

    for (T element in this) {
      if (test(element)) {
        if (first == null) {
          first = element;
          continue;
        }

        if (second == null) {
          second = element;
          break;
        }
      }
    }

    if (first == null || second == null) return this;

    return map((element) {
      if (element == first) return second!;
      if (element == second) return first!;

      return element;
    });
  }
}
