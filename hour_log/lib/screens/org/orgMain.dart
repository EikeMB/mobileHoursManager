import 'package:flutter/material.dart';
import 'package:hour_log/models/organization.dart';
import 'package:hour_log/services/auth.dart';

class Org extends StatefulWidget {
  Organization org;
  Org(this.org, {super.key});

  @override
  State<Org> createState() => _OrgState();
}

class _OrgState extends State<Org> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
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
      body: Text('Org name: ${widget.org.name}'),
    );
  }
}