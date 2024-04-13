import 'package:flutter/material.dart';
import 'package:hour_log/models/organization.dart';
import 'package:hour_log/models/user.dart';
import 'package:hour_log/screens/createOrg/create.dart';
import 'package:hour_log/screens/profile/changeUserName.dart';
import 'package:hour_log/services/auth.dart';
import 'package:hour_log/shared/constants.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserData?>(context);
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
        title: user != null ? Text(user.username) : null,
      ),

      body: user != null ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
        child: 
        Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: getUsernameColor(user.username),
            child: Text(user.username.substring(0, 2).toUpperCase(), style: const TextStyle(fontSize: 40.0, letterSpacing: 2.5)),
          ),
          const SizedBox(height: 30.0,),
          Center(
            child: Text(user.username,
            style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),)
          ),
          const SizedBox(height: 50.0,),
          Center(
            child: Text('Total time worked: ${user.getTotalHours().inHours} Hour(s) : ${user.getTotalHours().inMinutes % 60} Minute(s)',
            style: const TextStyle(fontSize: 17.0),),
          ),
          const SizedBox(height: 50.0,),
          Center(
            child: Text('Organizations joined: ${user.orgs.length}',
            style: const TextStyle(fontSize: 17.0),),
          )
        ],
      )) : null,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(context: context, builder: (context){
                return MultiProvider(providers: [StreamProvider<UserData?>.value(initialData: null, value: databaseService!.userData, child: const ChangeUserName(),),
                StreamProvider<List<Organization>?>.value(initialData: null, value: databaseService!.orgs, child: const ChangeUserName(),)],
                child: const ChangeUserName(),);
              });
        },
        icon: const Icon(Icons.change_circle_sharp),
        label: const Text("Change Username"),
        
      ),
    );
  }
}