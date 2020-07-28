import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName;
  String userEmail;
  File profilePic;

  // void getUserData() async {
  //   final user = await FirebaseAuth.instance.currentUser();
  //   userEmail = user.email;
  //   userName = user.displayName;
  //   // final userData =
  //   //     await Firestore.instance.collection('users').document(user.uid).get();

  //   // userName = userData['fullname'];
  //   // userEmail = userData['email'];
  // }

  // // Future getUserName() async {

  // //   final user = await FirebaseAuth.instance.currentUser();
  // //   return
  // // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeScreen'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (context, snapShot) {
          if (!snapShot.hasData) {
            return Center(
              child: SpinKitDoubleBounce(
                color: Colors.white,
                size: 40.0,
              ),
            );
          }
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('UserName: ${snapShot.data.documents[0]['fullName']}'),
                Text('UserEmail: ${snapShot.data.documents[0]['email']}'),
                Text(
                  'You Are Logged In',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.blueGrey,
                  elevation: 0.0,
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.0,
                      fontSize: 16.0,
                    ),
                  ),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
