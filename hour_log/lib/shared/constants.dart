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

Color getUsernameColor(String username) {
  final int hash = username.codeUnits.fold(0, (int prev, int curr) => prev + curr);
  final Random random = Random(hash);
  return Color.fromRGBO(
    random.nextInt(256), // R value
    random.nextInt(256), // G value
    random.nextInt(256), // B value
    1, // Opacity
  );
}

Duration parseDuration(String stringDuration){
    List<String> splitDuration = stringDuration.split(':');

    int hours = 0, minutes = 0, seconds = 0;

    hours = int.parse(splitDuration[0]);
    minutes = int.parse(splitDuration[1]);

    return Duration(hours: hours, minutes: minutes);
}
