/// To satisfy the Dart type system, sometimes
/// we need to explicitly call [key.toString()]
/// when converting a [Map<dynamic, dynamic>] to
/// a [Map<String, dynamic>].
///
/// Why not use [as] or [cast<>()]?
/// Dart has a funky type system, and these
/// will cause exceptions at runtime.
Map<String, dynamic> jsonifyMap(Map m) {
  return Map<String, dynamic>.fromEntries(
    m.entries.map(
      (me) => MapEntry(me.key.toString(), me.value),
    ),
  );
}
