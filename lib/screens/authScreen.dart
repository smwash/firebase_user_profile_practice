import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_user_profile/widgets/authForm.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  var message = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  AuthResult authResult;

  void _submitAuthForm(
    String userEmail,
    String userPassword,
    String fullname,
    bool isLogin,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: userEmail.trim(),
          password: userPassword.trim(),
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: userEmail.trim(),
          password: userPassword.trim(),
        );

        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'email': userEmail,
          'fullName': fullname,
        });
      }
    } on PlatformException catch (error) {
      if (error != null) {
        message = error.message;
        print(message);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: AuthForm(
            submitFn: _submitAuthForm,
            isLoading: _isLoading,
            message: message,
          ),
        ),
      ),
    );
  }
}
