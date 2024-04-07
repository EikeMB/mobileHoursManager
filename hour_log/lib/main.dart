import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hour_log/models/user.dart';
import 'package:hour_log/screens/authentication/authenticate.dart';
import 'package:hour_log/screens/wrapper.dart';
import 'package:hour_log/services/auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: const MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}




