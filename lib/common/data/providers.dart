import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/widgets/async_error.widget.dart';
import 'package:dishful/common/widgets/async_loading.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension WidgetRefExtension on WidgetRef {
  void set<T>(StateProvider<T> of, T to) {
    read(of.notifier).state = to;
  }
}

extension AsyncValueExtension<T> on AsyncValue<T> {
  Widget toWidget({
    required Widget Function(T) data,
  }) =>
      when(
        data: data,
        loading: asyncLoading,
        error: asyncError,
      );
}

typedef AsyncValueProvider<T> = AutoDisposeStateProvider<AsyncValue<T>>;

AsyncValueProvider<List<T?>> getAllProvider<T extends Serializable>(
  Client<T> client,
) {
  return StateProvider.autoDispose((ref) {
    final cancel = client.watchAll(
      (data) {
        ref.controller.update((state) => AsyncValue.data(data));
      },
      (error) {
        ref.controller.update((state) => AsyncValue.error(error));
      },
    );

    ref.onDispose(cancel);

    return AsyncValue.loading();
  });
}

AsyncValueProvider<T?> getProvider<T extends Serializable>(
  Client<T> client,
  String id,
) {
  return StateProvider.autoDispose((ref) {
    final cancel = client.watch(
      id,
      (data) {
        ref.controller.update((state) => AsyncValue.data(data));
      },
      (error) {
        ref.controller.update((state) => AsyncValue.error(error));
      },
    );

    ref.onDispose(cancel);

    return AsyncValue.loading();
  });
}

AsyncValueProvider<User?> currentUserProvider() {
  return StateProvider.autoDispose((ref) {
    final cancel = AuthService.watchCurrentUser(
      (data) {
        ref.controller.update((state) => AsyncValue.data(data));
      },
      (error) {
        ref.controller.update((state) => AsyncValue.error(error));
      },
    );

    ref.onDispose(cancel);

    return AsyncValue.loading();
  });
}
