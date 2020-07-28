import 'package:flutter/material.dart';

const kTextFieldDeco = InputDecoration(
  labelText: '',
  labelStyle: TextStyle(
    fontSize: 17.0,
    color: Colors.black,
    fontWeight: FontWeight.w600,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
    borderSide: BorderSide(
      color: Colors.black45,
      //Color(0xffefefef),
    ),
  ),
);
