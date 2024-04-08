

import 'package:flutter/material.dart';
import 'package:hour_log/models/organization.dart';
import 'package:hour_log/screens/home/orgCard.dart';
import 'package:hour_log/services/auth.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    final orgs = Provider.of<List<Organization>?>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[200],
        actions: [
          TextButton.icon(
            style: ButtonStyle(
              iconColor: MaterialStateProperty.all(Colors.black)
            ),
            icon: const Icon(Icons.person),
            onPressed: () async {
              await _auth.signOut();
            },
            label: const Text(
              'logout',
              style: TextStyle(
                color: Colors.black
              )
            ),
          )
        ],
        title: const Text('Home'),
      ),
      body: Column(
        children: orgs != null ? orgs.map((org) => OrgCard(org)).toList() : [const Text('no orgs')],
      ),
    );
  }
}