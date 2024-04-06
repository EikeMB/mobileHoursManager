import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hour_log/screens/authentication/authenticate.dart';
import 'package:hour_log/screens/authentication/register.dart';
import 'firebase_options.dart';
import 'package:hour_log/screens/authentication/login.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    home: Authenticate(),
  ));
}




