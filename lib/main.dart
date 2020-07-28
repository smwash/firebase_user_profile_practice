import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_user_profile/screens/authScreen.dart';
import 'package:firebase_user_profile/screens/homescreen.dart';
import 'package:firebase_user_profile/screens/splashscreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            }
            if (userSnapshot.hasData) {
              return HomeScreen();
            }
            return AuthScreen();
          }),
    );
  }
}
