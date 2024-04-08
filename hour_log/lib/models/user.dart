import 'package:hour_log/models/day.dart';

class AppUser{
  final String uid;

  AppUser(this.uid);
}


class UserData{
  final String uid;
  final String username;
  final List<String> orgs;
  final List<WorkDay> workDays;

  UserData(this.uid, this.username, this.orgs, this.workDays);


  Map<String, dynamic> getMapFromUserData() {



    return {
      'uid': uid,
      'name': username,
      'organizations': orgs,
      'workdays': workDays.map((workDay) => workDay.getMapFromWorkDay()).toList()
    };
  }
}