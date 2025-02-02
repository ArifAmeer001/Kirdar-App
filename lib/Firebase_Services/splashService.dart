import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:login_app/Auth/loginScreen.dart';
import 'package:login_app/Screens/HomeScreen.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if(user != null){
      Timer(
          const Duration(seconds: 3),
              () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen())));
    }else{
      Timer(
          const Duration(seconds: 3),
              () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen())));
    }
  }
}
