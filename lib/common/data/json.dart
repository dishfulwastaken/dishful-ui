import 'package:dishful/common/services/db.service.dart';

/// To satisfy the Dart type system, sometimes
/// we need to explicitly call [key.toString()]
/// when converting a [Map<dynamic, dynamic>] to
/// a [Json].
///
/// Why not use [as] or [cast<>()]?
/// Dart has a funky type system, and these
/// will cause exceptions at runtime.
Json jsonifyMap(Map m) {
  return Json.fromEntries(
    m.entries.map(
      (me) => MapEntry(me.key.toString(), me.value),
    ),
  );
}
