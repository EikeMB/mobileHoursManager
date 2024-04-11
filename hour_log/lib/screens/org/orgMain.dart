import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hour_log/models/organization.dart';
import 'package:hour_log/models/user.dart';
import 'package:hour_log/services/auth.dart';
import 'package:hour_log/shared/constants.dart';
import 'package:provider/provider.dart';

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
    final user = Provider.of<UserData?>(context);
    final Duration totalTime = widget.org.getTotalHours();
    final Duration myTotalTime = user !=null ? widget.org.getUserTotalHours(user.uid) : const Duration();
    String sDuration = "${myTotalTime.inHours}:${myTotalTime.inMinutes.remainder(60)}:${(myTotalTime.inSeconds.remainder(60))}"; 
    String sTotalDuration = "${totalTime.inHours}:${totalTime.inMinutes.remainder(60)}:${(totalTime.inSeconds.remainder(60))}"; 
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
              Navigator.pop(context);
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(widget.org.name, style: const TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.bold
              ),),
            ),
            const SizedBox(height: 5.0,),
            Center(
              child: Text(widget.org.code, style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.normal
              ),),
              
            ),
            const SizedBox(height: 80.0,),
                Text('Total work time: $sTotalDuration',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic 
                ),),
                Text('My org work time: $sTotalDuration',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic 
                ),
            ),
            const SizedBox(height: 250.0,),
            const Text('Members:', style: TextStyle(fontSize: 20.0),),
            const SizedBox(height: 10.0,),
            SingleChildScrollView(
              child: Row(
                children: 
                  widget.org.members.isNotEmpty ? widget.org.members.map((member) => 
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: getUsernameColor(member.username),
                    child: Text(member.username.substring(0, 2).toUpperCase(), style: const TextStyle(fontSize: 20.0, letterSpacing: 2.5)),
                  )).expand((widget) => [widget, const SizedBox(width: 15,)]).toList() : [const Text('No Members')]
                  
              ),
            ),
            const SizedBox(height: 10.0,),
            const Text('Owner:', style: TextStyle(fontSize: 20.0),),
            const SizedBox(height: 10.0,),
            CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.lightBlue[100],
                  child: Text(widget.org.owner.username.substring(0, 2).toUpperCase(), style: const TextStyle(fontSize: 20.0, letterSpacing: 2.5)),
                )
          ],
        ),
        
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {
            
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}