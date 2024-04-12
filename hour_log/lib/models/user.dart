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

  static UserData getUserDataFromMap(Map<String,  dynamic> map){
    String name = map['name'];
    List<String> orgs = List.from(map['organizations']);
    String uid = map['uid'];
    List<WorkDay> days = [];
    if(map['workdays'].isEmpty){
      days = List<WorkDay>.empty();
    }
    else{
      for(Map<String, dynamic> map in map['workdays']){
        days.add(WorkDay.dayFromMap(map));
      }
    }

    return UserData(uid, name, orgs, days);
  }
}