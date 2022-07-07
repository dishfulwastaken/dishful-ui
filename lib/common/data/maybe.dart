extension MaybeExtension<T> on Iterable<T> {
  T? get maybeFirst => isEmpty ? null : first;

  T? maybeSingleWhere(bool Function(T) test) {
    try {
      return singleWhere(test);
    } on StateError catch (_) {
      return null;
    }
  }
}
