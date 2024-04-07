

import 'package:flutter/material.dart';
import 'package:hour_log/models/user.dart';
import 'package:hour_log/screens/authentication/authenticate.dart';
import 'package:hour_log/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser?>(context);


    return user != null ? const Home() : const Authenticate();
  }
}