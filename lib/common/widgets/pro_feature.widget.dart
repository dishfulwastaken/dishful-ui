import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/user_meta.dart';
import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProFeature extends ConsumerWidget {
  late final AsyncValueProvider<UserMeta?> userMetaProvider;
  final Widget child;

  ProFeature({required this.child, Key? key}) : super(key: key) {
    final id = AuthService.currentUser?.uid;
    if (id == null) throw "No current user";

    userMetaProvider = getProvider(DbService.publicDb.userMeta, id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPro = ref.watch(
      userMetaProvider.select((value) => value.asData?.value?.isPro ?? false),
    );
    return Container();
  }
}
