import 'package:async/async.dart';
import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef MyProvider<T> = AutoDisposeStateProvider<Result<T>>;
typedef LoadingWidgetBuilder = Widget Function();
typedef ErrorWidgetBuilder = Widget Function(
  Object error,
  StackTrace? stackTrace,
);
typedef DataWidgetBuilder<T> = Widget Function(T data);

extension ResultExtension<T> on Result<T> {
  Widget toWidget({
    required LoadingWidgetBuilder loading,
    required ErrorWidgetBuilder error,
    required DataWidgetBuilder<T> data,
  }) {
    if (isError) {
      final errorResult = asError!;

      return error(
        errorResult.error,
        errorResult.stackTrace,
      );
    }

    final value = asValue!.value;

    final isLoadingOne = value == null;
    final isLoadingAll = !isLoadingOne &&
        value is List &&
        value.isNotEmpty &&
        value.first == null;

    return isLoadingOne || isLoadingAll ? loading() : data(value);
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

MyProvider<User?> currentUserProvider() {
  return StateProvider.autoDispose((ref) {
    final cancel = AuthService.watchCurrentUser(
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
