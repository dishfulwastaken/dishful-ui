import 'package:dishful/common/widgets/avatar.widget.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Avatar(
        onPressed: () {
          print("Editing profile pic?");
        },
      ),
    );
  }
}
