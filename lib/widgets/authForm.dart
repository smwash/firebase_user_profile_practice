import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  final message;
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  const AuthForm({Key key, this.isLoading, this.submitFn, this.message})
      : super(key: key);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  String userEmail = '';
  String userPassword = '';
  String userNames = '';
  bool isLogin = true;
  File profilePic;

  void _getPickedImage(File pickedImage) {
    profilePic = pickedImage;
  }

  void _submitForm() {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      _formKey.currentState.save();

      widget.submitFn(
        userEmail.trim(),
        userPassword.trim(),
        userNames.trim(),
        isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            if (!isLogin)
              UserProfilePicturePicker(pickedFileImage: _getPickedImage),
            SizedBox(
              height: 10.0,
            ),
            Text(
              isLogin ? 'Login' : 'Sign Up',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              autofocus: false,
              decoration: kTextFieldDeco.copyWith(
                labelText: 'Email',
                prefixIcon: Icon(
                  Icons.alternate_email,
                  color: Colors.black,
                ),
              ),
              validator: (value) {
                if (value.isEmpty || !value.contains('@')) {
                  return 'Please Enter a vaid email';
                }
                return null;
              },
              onSaved: (value) {
                userEmail = value;
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              autofocus: false,
              obscureText: _obscureText,
              decoration: kTextFieldDeco.copyWith(
                labelText: 'Password',
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Colors.black,
                ),
                suffixIcon: IconButton(
                  icon: _obscureText
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility),
                  onPressed: () => setState(() {
                    _obscureText = !_obscureText;
                  }),
                ),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 7) {
                  return 'Password must be 7 characters long';
                }
                return null;
              },
              onSaved: (value) {
                userPassword = value;
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            if (!isLogin)
              TextFormField(
                autofocus: false,
                decoration: kTextFieldDeco.copyWith(
                  labelText: 'Full Name',
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty || value.length < 2) {
                    return 'Please Enter a valid name';
                  }
                  return null;
                },
                onSaved: (value) {
                  userNames = value;
                },
              ),
            SizedBox(
              height: 8.0,
            ),
            if (widget.isLoading)
              SpinKitDoubleBounce(
                color: Colors.lightBlueAccent,
                size: 40.0,
              ),
            Container(
              child: Text(
                widget.message,
                style: TextStyle(
                  color: Colors.red[400],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (!widget.isLoading)
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.blueGrey,
                elevation: 0.0,
                child: Text(
                  isLogin ? 'LogIn' : 'SignUp',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.0,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: _submitForm,
              ),
            if (!widget.isLoading)
              FlatButton(
                child: Text(
                    isLogin ? 'Create Account' : 'I already have an account'),
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}

class UserProfilePicturePicker extends StatefulWidget {
  final void Function(File pickedImage) pickedFileImage;

  const UserProfilePicturePicker({Key key, this.pickedFileImage})
      : super(key: key);
  @override
  _UserProfilePicturePickerState createState() =>
      _UserProfilePicturePickerState();
}

class _UserProfilePicturePickerState extends State<UserProfilePicturePicker> {
  File pickedUserImage;

  void _pickedImage() async {
    final picker = ImagePicker();
    final pickedImageFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      pickedUserImage = File(pickedImageFile.path);
    });
    widget.pickedFileImage(
      File(pickedImageFile.path),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage:
              pickedUserImage != null ? FileImage(pickedUserImage) : null,
        ),
        FlatButton.icon(
          onPressed: _pickedImage,
          icon: Icon(Icons.image),
          label: Text('Add Image'),
        ),
      ],
    );
  }
}
