import 'package:async/async.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension MyWidgetRef on WidgetRef {
  void set<T>(StateProvider<T> of, T to) {
    read(of.notifier).state = to;
  }
}

typedef MyProvider<T> = AutoDisposeStateProvider<Result<T>>;
typedef LoadingWidgetBuilder = Widget Function();
typedef ErrorWidgetBuilder = Widget Function(
  Object error,
  StackTrace? stackTrace,
);
typedef DataWidgetBuilder<T> = Widget Function(T data);

extension MyProviderExtension<T> on MyProvider<T> {
  Widget when(
    WidgetRef ref, {
    required LoadingWidgetBuilder loading,
    required ErrorWidgetBuilder error,
    required DataWidgetBuilder<T> data,
  }) {
    final result = ref.watch(this);

    final isError = result.isError;
    if (isError)
      return error(
        result.asError!.error,
        result.asError?.stackTrace,
      );

    final value = result.asValue!.value;
    final isLoadingSingle = value == null;
    final isLoadingMultiple = !isLoadingSingle &&
        value is List &&
        value.isNotEmpty &&
        value.first == null;
    if (isLoadingSingle || isLoadingMultiple) return loading();

    return data(value);
  }
}

MyProvider<List<T?>> getAllProvider<T extends Serializable>(
  Client<T> client,
) {
  return StateProvider.autoDispose((ref) {
    final cancel = client.watchAll(
      (data) {
        ref.controller.update((state) => Result.value(data));
      },
      (error) {
        ref.controller.update((state) => Result.error(error));
      },
    );

    ref.onDispose(cancel);

    return Result.value([null]);
  });
}

MyProvider<T?> getProvider<T extends Serializable>(
  Client<T> client,
  String id,
) {
  return StateProvider.autoDispose((ref) {
    final cancel = client.watch(
      id,
      (data) {
        ref.controller.update((state) => Result.value(data));
      },
      (error) {
        ref.controller.update((state) => Result.error(error));
      },
    );

    ref.onDispose(cancel);

    return Result.value(null);
  });
}
