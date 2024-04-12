import 'package:flutter/material.dart';
import 'package:hour_log/models/organization.dart';
import 'package:hour_log/models/user.dart';
import 'package:hour_log/screens/org/orgMain.dart';
import 'package:hour_log/shared/constants.dart';
import 'package:provider/provider.dart';

class OrgCard extends StatefulWidget {
  Organization org;
  OrgCard(this.org, {super.key});

  @override
  State<OrgCard> createState() => _OrgCardState();
}

class _OrgCardState extends State<OrgCard> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData?>(context);

    Duration totalTime = user != null ? widget.org.getUserTotalHours(user.uid) : const Duration();

    if(user != null){
      for (var element in user.workDays) 
    {
      if(element.org == widget.org.name)
      {
        totalTime += element.totalTime;
      }
    }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 20.0),
      child: Card(
        elevation: 10.0,
        color: Colors.purple[50],
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => StreamProvider<UserData?>.value(
              initialData: null,
              value: databaseService!.userData,
              child: Org(widget.org),
            )));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(widget.org.name, style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold
                  ),),
                  
                ],
              ),
              const SizedBox(height: 20.0,),
              Text("Total time worked: ${totalTime.inHours}:${totalTime.inMinutes%60}"),
              const SizedBox(height: 20.0,),
              Text("Join using code: ${widget.org.code}"),
              
            ],
          ),
          ),
        )
        ),
    );
  }
}