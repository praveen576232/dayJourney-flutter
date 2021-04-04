import 'dart:async';

import 'package:daybook/screens/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerfi extends StatefulWidget {
  @override
  _EmailVerfiState createState() => _EmailVerfiState();
}

class _EmailVerfiState extends State<EmailVerfi> {
  Timer timer;
  User user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    user.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 1), checkEmailVerfication);
    // TODO: implement initState
    super.initState();
  }

  checkEmailVerfication(_) {
    user = FirebaseAuth.instance.currentUser;
    user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
            "An email ${user.email} has just been sent to you. Click the link provider to complete registration."),
        SizedBox(height: 20),
        CircularProgressIndicator()
      ],
    ));
  }
}
