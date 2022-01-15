import 'package:dishful/common/data/color.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/services/route.service.dart';
import 'package:dishful/pages/auth/logo.widget.dart';
import 'package:dishful/pages/auth/sign-in.widget.dart';
import 'package:dishful/pages/auth/sign-up.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthPage extends ConsumerWidget {
  late final MyProvider<User?> userProvider;
  final _controller = PageController();

  AuthPage() {
    userProvider = currentUserProvider();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userResult = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: HexColor.fromHex("#ff80aa"),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 38),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Current User: ${userResult.asValue?.value}"),
            Logo(),
            Spacer(),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 326),
              child: PageView(
                controller: _controller,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  SignIn(
                    toSignUp: () => _controller.animateToPage(
                      1,
                      duration: Duration(milliseconds: 1400),
                      curve: Curves.easeInOut,
                    ),
                  ),
                  SignUp(
                    toSignIn: () => _controller.animateToPage(
                      0,
                      duration: Duration(milliseconds: 1400),
                      curve: Curves.easeInOut,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
