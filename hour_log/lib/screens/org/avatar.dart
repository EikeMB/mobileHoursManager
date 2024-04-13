import 'package:flutter/material.dart';
import 'package:hour_log/models/organization.dart';
import 'package:hour_log/models/user.dart';
import 'package:hour_log/screens/org/userHours.dart';
import 'package:hour_log/shared/constants.dart';

class Avatar extends StatelessWidget {
  final UserData user;
  final Organization org;
  const Avatar(this.user, this.org, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserHours(org, user)));
      },
      child: Row(
        children: [CircleAvatar(
            radius: 35,
            backgroundColor: getUsernameColor(user.username),
            child: Text(user.username.substring(0, 2).toUpperCase(), style: const TextStyle(fontSize: 20.0, letterSpacing: 2.5)),
          ),
          const SizedBox(width: 20.0,)
        ]
      ),
    );
  }
}