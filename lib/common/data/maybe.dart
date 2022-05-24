extension MaybeExtension<T> on Iterable<T> {
  T? get maybeFirst => isEmpty ? null : first;
}
