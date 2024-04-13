import 'package:hour_log/models/day.dart';
import 'package:table_calendar/table_calendar.dart';

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

  WorkDay? getWorkdayFromDay(String org, DateTime start){
    try {
      return workDays.firstWhere(
      (day) => isSameDay(day.startTime, start) && org == day.org);
    } catch (e) {
      return null;
    }
  }


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