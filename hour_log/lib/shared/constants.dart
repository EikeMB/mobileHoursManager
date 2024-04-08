import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hour_log/services/database.dart';

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

DatabaseService? databaseService;

void createDatabaseService(String uid){
   databaseService = DatabaseService(uid);
}

String generateRandomString(int length) {
  final random = Random();
  const availableChars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final randomString = List.generate(length,
      (index) => availableChars[random.nextInt(availableChars.length)]).join();

  return randomString;
}
