import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/services/subscription.service.dart';
import 'package:dishful/common/widgets/dishful_error.widget.dart';
import 'package:dishful/common/widgets/dishful_loading.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

extension WidgetRefExtension on WidgetRef {
  void set<T>(StateProvider<T> of, T to) {
    read(of.notifier).state = to;
  }
}

extension SelectFromDataExtension<T> on ProviderBase<AsyncValue<T>> {
  ProviderListenable<AsyncValue<U>> selectFromData<U>(
    U Function(T) selector, {
    T? initialValue,
  }) {
    return this.select((value) => initialValue != null && value.isLoading
        ? AsyncValue.data(selector(initialValue))
        : value.whenData(selector));
  }
}

extension StreamExtension on Stream {
  void close() {
    // TODO: verify that this works and also try using take(0)
    this.take(1);
  }
}

extension AsyncValueExtension<T> on AsyncValue<T> {
  AsyncValue<Tuple2<T, U>> and<U>(AsyncValue<U> other) {
    if (this is AsyncError) {
      final error = this as AsyncError<T>;
      return AsyncError(error.error, stackTrace: error.stackTrace);
    } else if (other is AsyncError) {
      final error = other as AsyncError<U>;
      return AsyncError(error.error, stackTrace: error.stackTrace);
    } else if (this is AsyncLoading || other is AsyncLoading) {
      return AsyncLoading();
    } else if (this is AsyncData && other is AsyncData) {
      return AsyncData(Tuple2<T, U>(this.asData!.value, other.asData!.value));
    }

    throw "Failed to add AsyncValues";
  }

  /// Note: [initialValue] is redundant if [this] provider
  /// is using [SelectFromDataExtension] with an [initialValue].
  Widget toWidget({
    required Widget Function(T) data,
    T? initialValue,
    Widget? loading,
    bool allowError = false,
  }) =>
      when(
        data: data,
        loading: () => initialValue != null
            ? data(initialValue)
            : (loading ?? DishfulLoading()),
        error: (error, trace) => allowError
            ? Error.throwWithStackTrace(
                error,
                trace ?? new StackTrace.fromString("Missing stack trace"),
              )
            : DishfulError(
                error: error.toString(),
                stack: trace.toString(),
              ),
      );
}

FutureProvider<List<T>> getAllProvider<T extends Serializable>(
  Client<T> client, {
  List<Filter>? filters,
}) =>
    FutureProvider((ref) => client.getAll(filters: filters));

FutureProvider<T?> getProvider<T extends Serializable>(
  Client<T> client, {
  required String id,
}) =>
    FutureProvider((ref) => client.get(id));

AutoDisposeStreamProvider<List<T>> watchAllProvider<T extends Serializable>(
  Client<T> client, {
  List<Filter>? filters,
}) =>
    StreamProvider.autoDispose((ref) async* {
      final stream = client.watchAll(filters: filters);
      ref.onDispose(stream.close);
      await for (final value in stream) yield value;
    });

AutoDisposeStreamProvider<T?> watchProvider<T extends Serializable>(
  Client<T> client, {
  required String id,
}) =>
    StreamProvider.autoDispose((ref) async* {
      final stream = client.watch(id);
      ref.onDispose(stream.close);
      await for (final value in stream) yield value;
    });

AutoDisposeStreamProvider<User?> watchCurrentUserProvider() =>
    StreamProvider.autoDispose((ref) async* {
      final stream = AuthService.watchCurrentUser();
      ref.onDispose(stream.close);
      await for (final value in stream) yield value;
    });

typedef AsyncValueProvider<T> = ProviderBase<AsyncValue<T>>;
typedef AsyncValueListenable<T> = ProviderListenable<AsyncValue<T>>;

AsyncValueProvider<T?> oneProvider<T extends Serializable>(
  Client<T> client, {
  required String id,
}) =>
    SubscriptionService.isCurrentUserSubscribed
        ? watchProvider(client, id: id)
        : getProvider(client, id: id);

AsyncValueProvider<List<T>> allProvider<T extends Serializable>(
  Client<T> client, {
  List<Filter>? filters,
}) =>
    SubscriptionService.isCurrentUserSubscribed
        ? watchAllProvider(client, filters: filters)
        : getAllProvider(client, filters: filters);
