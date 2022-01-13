import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/route.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  final TextEditingController _emailController1 = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _emailController2 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dishful UI')),
      body: Center(
          child: Column(
        children: [
          Text("Current User: ${AuthService.currentUser}"),
          Text("Sign In"),
          TextField(
            controller: _emailController2,
            decoration: InputDecoration.collapsed(hintText: 'Email'),
          ),
          TextField(
            controller: _passwordController2,
            decoration: InputDecoration.collapsed(hintText: 'Password'),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.signIn(
                email: _emailController2.text,
                password: _passwordController2.text,
              );
            },
            child: const Text("Sign In"),
          ),
          Text("Sign Up"),
          TextField(
            controller: _emailController1,
            decoration: InputDecoration.collapsed(hintText: 'Email'),
          ),
          TextField(
            controller: _passwordController1,
            decoration: InputDecoration.collapsed(hintText: 'Password'),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.signUp(
                email: _emailController1.text,
                password: _passwordController1.text,
              );
            },
            child: const Text("Sign Up"),
          ),
        ],
      )),
    );
  }
}
