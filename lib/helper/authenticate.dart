import 'package:flutter/material.dart';
import 'package:untitled/views/signup.dart';

import '../views/signIn.dart';

class Authenticate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authenticate> {
  bool showSignIn = true;

  void toggle() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggle);
    } else {
      return SignUp(toggle);
    }
  }
}
