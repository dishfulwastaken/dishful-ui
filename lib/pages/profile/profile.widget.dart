import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/subscription.dart';
import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/widgets/avatar.widget.dart';
import 'package:dishful/common/widgets/editable.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  late final AutoDisposeStreamProvider<User?> userProvider;
  late final AutoDisposeStreamProvider<Subscription?> subscriberProvider;

  ProfilePage({Key? key}) : super(key: key) {
    final id = AuthService.currentUser.uid;

    userProvider = watchCurrentUserProvider();
    subscriberProvider =
        watchProvider(DbService.publicDb.subscriptions, id: id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userValue = ref.watch(userProvider);
    final subscriberValue = ref.watch(subscriberProvider);

    final avatar = Avatar(
      onPressed: () {
        print("Editing profile pic?");
      },
    );

    return EditableScaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: userValue.and(subscriberValue).toWidget(
        data: (userTuple) {
          final user = userTuple.item1;
          final subscription = userTuple.item2;

          return ListView(
            padding: EdgeInsets.all(12),
            children: [
              avatar,
              Container(height: 12),
              EditableTextField(
                prefix: "Display name:",
                initialValue: user?.displayName,
                style: TextStyle(color: Colors.black, fontSize: 13),
                saveValue: (displayName) async {
                  await user?.updateDisplayName(displayName);
                },
              ),
              Text("Email: ${user?.email}"),
              Text("Is pro user: ${subscription?.isCurrentlySubscribed}")
            ],
          );
        },
      ),
    );
  }
}
