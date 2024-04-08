import 'package:flutter/material.dart';
import 'package:hour_log/services/auth.dart';

class CreateOrg extends StatefulWidget {
  const CreateOrg({super.key});

  @override
  State<CreateOrg> createState() => _CreateOrgState();
}

class _CreateOrgState extends State<CreateOrg> {

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
        title: const Text('Create Org'),
      ),
    );
  }
}