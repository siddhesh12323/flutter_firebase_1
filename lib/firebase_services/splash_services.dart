import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_1/ui/auth/login_screen.dart';
import 'package:flutter_firebase_1/ui/posts/posts_screen.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      Timer(Duration(seconds: 2), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PostsScreen()));
      });
    } else {
      Timer(Duration(seconds: 2), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      });
    }
  }
}
