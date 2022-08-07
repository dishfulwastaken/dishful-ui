extension MapWithIndexExtension<T> on List<T> {
  List<U> mapWithIndex<U>(U Function(int, T) toElement) {
    return this
        .asMap()
        .map(((key, value) {
          final element = toElement(key, value);
          return MapEntry(key, element);
        }))
        .values
        .toList();
  }
}
