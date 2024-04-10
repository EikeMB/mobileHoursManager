

import 'package:flutter/material.dart';
import 'package:hour_log/models/organization.dart';
import 'package:hour_log/models/user.dart';
import 'package:hour_log/screens/createOrg/create.dart';
import 'package:hour_log/screens/createOrg/joinOrg.dart';
import 'package:hour_log/screens/home/orgCard.dart';
import 'package:hour_log/services/auth.dart';
import 'package:hour_log/shared/constants.dart';
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
        children: orgs != null ? orgs.map((org) => StreamProvider.value(value: databaseService?.userData, initialData: null, child: OrgCard(org),)).toList()  : [const Text('no orgs')],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              showModalBottomSheet(context: context, builder: (context){
                return StreamProvider<UserData?>.value(initialData: null, value: databaseService!.userData, child: const JoinOrg(),);
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('Join new Org'),
          ),
          const SizedBox(height: 20.0,),
          FloatingActionButton.extended(
            onPressed: () {
              showModalBottomSheet(context: context, builder: (context){
                return StreamProvider<UserData?>.value(initialData: null, value: databaseService!.userData, child: const CreateOrg(),);
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('Create new Org'),
          )
        ],
      )
        
      );
    
  }
}