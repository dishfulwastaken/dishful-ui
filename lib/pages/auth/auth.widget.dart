import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/common/widgets/dishful_logo.widget.dart';
import 'package:dishful/pages/auth/sign-in.widget.dart';
import 'package:dishful/pages/auth/sign-up.widget.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthPage extends ConsumerWidget {
  final _controller = PageController(viewportFraction: 1.2);

  void _animateToPage(int page) => _controller.animateToPage(
        page,
        duration: Duration(milliseconds: 750),
        curve: Cubic(.30, .70, .70, .30),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Palette.primary,
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 38, horizontal: 64),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DishfulLogo(size: 180, placeholderColor: Palette.primaryDark),
            Text("Dishful", style: context.headlineMedium).paddingOnly(top: 6),
            Spacer(),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 412, maxWidth: 800),
              child: PageView(
                controller: _controller,
                physics: NeverScrollableScrollPhysics(),
                clipBehavior: Clip.none,
                children: [
                  SignIn(toSignUp: () => _animateToPage(1)),
                  SignUp(toSignIn: () => _animateToPage(0)),
                ]
                    .map((page) => FractionallySizedBox(
                          widthFactor: 1 / _controller.viewportFraction,
                          child: page,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
