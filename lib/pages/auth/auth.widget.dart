import 'package:dishful/common/data/color.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/route.service.dart';
import 'package:dishful/pages/auth/sign-in/sign-in.widget.dart';
import 'package:dishful/pages/auth/sign-up/sign-up.widget.dart';
import 'package:dishful/pages/sign-in/sign-in-text-field.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

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
      body: Center(
        child: Column(
          children: [
            Text("Current User: ${userResult.asValue?.value}"),
            Container(
              width: 180,
              height: 180,
              child: SvgPicture.asset(
                "temp-logo.svg",
                fit: BoxFit.fill,
                allowDrawingOutsideViewBox: true,
                placeholderBuilder: (context) => SizedBox(
                  width: 125,
                  height: 125,
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor.fromHex("#ff4d88"),
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                "Dishful",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 76,
                  fontFamily: "SweetApricot",
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.all(22),
              child: PageView(
                controller: _controller,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  SignIn(
                    toSignUp: () => _controller.animateToPage(
                      1,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    ),
                  ),
                  SignUp(
                    toSignIn: () => _controller.animateToPage(
                      0,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    ),
                  ),
                ],
              ),
            ),

            // Text("Sign In"),
            // TextField(
            //   controller: _emailController2,
            //   decoration: InputDecoration.collapsed(hintText: 'Email'),
            // ),
            // TextField(
            //   controller: _passwordController2,
            //   decoration: InputDecoration.collapsed(hintText: 'Password'),
            // ),
            // TextButton(
            //   onPressed: () async {
            //     await AuthService.signIn(
            //       email: _emailController2.text,
            //       password: _passwordController2.text,
            //     );
            //   },
            //   child: const Text("Sign In"),
            // ),
            // Text("Sign Up"),
            // TextField(
            //   controller: _emailController1,
            //   decoration: InputDecoration.collapsed(hintText: 'Email'),
            // ),
            // TextField(
            //   controller: _passwordController1,
            //   decoration: InputDecoration.collapsed(hintText: 'Password'),
            // ),
            // TextButton(
            //   onPressed: () async {
            //     await AuthService.signUp(
            //       email: _emailController1.text,
            //       password: _passwordController1.text,
            //     );
            //   },
            //   child: const Text("Sign Up"),
            // ),
          ],
        ),
      ),
    );
  }
}
