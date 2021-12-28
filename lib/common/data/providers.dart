import 'package:dishful/common/services/db.service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// FutureProvider<List<T>> getAllProvider<T extends Serializable>(
//   Client<T> client,
// ) =>
//     FutureProvider<List<T>>((ref) async {
//       return await client.getAll();
//     });

// FutureProvider<T?> getProvider<T extends Serializable>(
//   Client<T> client,
//   String id,
// ) =>
//     FutureProvider<T?>((ref) async => await client.get(id));

final localDb = DbService.getDb(DbProvider.hive);
final shareDb = DbService.getDb(DbProvider.firebase);

AutoDisposeStreamProvider<List<T?>> getAllProvider<T extends Serializable>(
  Client<T> client,
) {
  return StreamProvider.autoDispose<List<T?>>((ref) async* {
    /// We yield a list with null here because Riverpod needs
    /// a value so that it knows that the data has loaded but in
    /// this case there is none.
    final initialValues = await client.getAll();
    yield initialValues.isEmpty ? [null] : initialValues;

    await for (final _ in client.watch()) {
      final latestValues = await client.getAll();
      yield latestValues.isEmpty ? [null] : latestValues;
    }
  });
}

AutoDisposeStreamProvider<T?> getProvider<T extends Serializable>(
  Client<T> client,
  String id,
) {
  return StreamProvider.autoDispose<T?>((ref) async* {
    final noValue = await client.get(id) == null;

    if (noValue) yield null;
    await for (final _ in client.watch(id: id)) {
      yield await client.get(id);
    }
  });
}
