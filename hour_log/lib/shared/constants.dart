import 'package:flutter/material.dart';
import 'package:hour_log/screens/createOrg/create.dart';
import 'package:hour_log/screens/home/home.dart';
import 'package:hour_log/screens/profile/profile.dart';
import 'package:hour_log/screens/wrapper.dart';
import 'package:hour_log/shared/loading.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 2.0)
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.purple, width: 2.0)
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color:  Colors.red)
  )
);


