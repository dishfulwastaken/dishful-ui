import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/user_meta.dart';
import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/widgets/avatar.widget.dart';
import 'package:dishful/common/widgets/editable.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  late final AsyncValueProvider<User> userProvider;
  late final AsyncValueProvider<UserMeta> userMetaProvider;

  ProfilePage({Key? key}) : super(key: key) {
    final id = AuthService.currentUser?.uid;
    if (id == null) throw "No current user";

    userProvider = currentUserProvider();
    userMetaProvider = getProvider(DbService.publicDb.userMeta, id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userValue = ref.watch(userProvider);
    final userMetaValue = ref.watch(userMetaProvider);

    final avatar = Avatar(
      onPressed: () {
        print("Editing profile pic?");
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: userValue.and(userMetaValue).toWidget(
        data: (userTuple) {
          final user = userTuple.item1;
          final userMeta = userTuple.item2;

          return ListView(
            padding: EdgeInsets.all(12),
            children: [
              avatar,
              Container(height: 12),
              EditableTextField(
                prefix: "Display name:",
                initialValue: user.displayName,
                style: TextStyle(color: Colors.black, fontSize: 13),
                onSave: (displayName) async {
                  await user.updateDisplayName(displayName);
                },
              ),
              Text("Email: ${user.email}"),
              Text("Is pro user: ${userMeta.isPro}")
            ],
          );
        },
      ),
    );
  }
}
