import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:hour_log/models/day.dart';
import 'package:hour_log/models/organization.dart';
import 'package:hour_log/models/user.dart';
import 'package:hour_log/screens/org/avatar.dart';
import 'package:hour_log/screens/org/podium.dart';
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


  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  Duration? breakTime;

  

  List<UserData> _getTopThree(Organization org){
    List<UserData> members = [];
    for(UserData member in org.members){
      members.add(member);
    }
    members.add(org.owner);
    members.sort((b, a) => org.getUserTotalHours(a.uid).compareTo(org.getUserTotalHours(b.uid)));

    return members;
  }


  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });

      // After date is picked, pick the start time
      await _pickStartTime(context);
    }
  }

  Future<void> _pickStartTime(BuildContext context) async {
    final TimeOfDay? pickedStartTime = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
    );

    if (pickedStartTime != null && pickedStartTime != startTime) {
      setState(() {
        startTime = pickedStartTime;
      });

      // After start time is picked, pick the end time
      await _pickEndTime(context);
    }
  }

  Future<void> _pickEndTime(BuildContext context) async {
    final TimeOfDay? pickedEndTime = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
    );

    if (pickedEndTime != null && pickedEndTime != endTime) {
      setState(() {
        endTime = pickedEndTime;
      });

      await _pickDuration(context);
    }
  }


  Future<void> _pickDuration(BuildContext context) async {
    final Duration? pickedDuration = await showDurationPicker(context: context, initialTime: breakTime ?? const Duration(minutes: 30));

    if(pickedDuration != null && pickedDuration != breakTime){
      setState(() {
        breakTime = pickedDuration;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData?>(context);

    

    List<UserData> topThree = _getTopThree(widget.org);
    final Duration totalTime = widget.org.getTotalHours();
    final Duration myTotalTime = user !=null ? widget.org.getUserTotalHours(user.uid) : const Duration();
    String sDuration = "${myTotalTime.inHours}H:${myTotalTime.inMinutes.remainder(60)}"; 
    String sTotalDuration = "${totalTime.inHours}H:${totalTime.inMinutes.remainder(60)}"; 
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
        title: const Text('Organization'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: SingleChildScrollView(
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
                  Text('My org work time: $sDuration',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontStyle: FontStyle.italic 
                  ),
              ),
              const SizedBox(height: 50.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: topThree.isEmpty ? const [Text("No Users")] : [
                  Podium(topThree, widget.org)
                ],
              ),
              const SizedBox(height: 70.0,),
              const Text('Members:', style: TextStyle(fontSize: 20.0),),
              const SizedBox(height: 10.0,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: 
                    widget.org.members.isNotEmpty ? widget.org.members.map((member) => Avatar(member, widget.org)).toList() : [const Text('No Members')]
                    
                ),
              ),
              const SizedBox(height: 10.0,),
              const Text('Owner:', style: TextStyle(fontSize: 20.0),),
              const SizedBox(height: 10.0,),
              Avatar(widget.org.owner, widget.org)
            ],
          ),
        ),
        
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () async {
            await _pickDate(context);

            if(selectedDate != null && startTime != null && endTime != null && breakTime != null && user != null){
              DateTime startDateTime = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, startTime!.hour, startTime!.minute);
              DateTime endDateTime = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, endTime!.hour, endTime!.minute);

              user.workDays.add(WorkDay(widget.org.code, startDateTime, endDateTime, breakTime!));

              if(widget.org.owner.uid == user.uid){
                widget.org.owner = user;
              }
              else{
                List<UserData> members = [];
                for(UserData member in widget.org.members){
                  if(member.uid == user.uid){
                    members.add(user);
                  }
                  else{
                    members.add(member);
                  }
                }
                widget.org.members = members;
              }

              dynamic resultUser = await databaseService!.updateUserData(user.username, user.orgs, user.workDays);
              dynamic resultOrg = await databaseService!.updateOrganizationData(widget.org.name, widget.org.code, widget.org.members, widget.org.owner);

              selectedDate = null;
              startTime = null;
              endTime = null;
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}