
import 'package:hour_log/models/day.dart';
import 'package:hour_log/models/user.dart';

class Organization {
  String name;
  String code;
  List<UserData> members;
  UserData owner;

  Organization(this.name, this.code, this.members, this.owner);
  
  Duration getTotalHours(){
    Duration totalTime = const Duration();
    for(WorkDay day in owner.workDays){
        if(day.org == code){
          totalTime += day.totalTime;
        }
    }
    for(UserData member in members){
      for(WorkDay day in member.workDays){
        if(day.org == code){
          totalTime += day.totalTime;
        }
      }
    }

    return totalTime;
  }

  Duration getUserTotalHours(String uid){
    Duration totalTime = const Duration();
    if(owner.uid == uid){
      for(WorkDay day in owner.workDays){
        if(day.org == code){
          totalTime += day.totalTime;
        }
      }
    }
    else{
      for(UserData member in members){
      if(member.uid == uid){
        for(WorkDay day in member.workDays){
        if(day.org == code){
          totalTime += day.totalTime;
        }
      }
      }
      
    }
    }
    
    return totalTime;
  }
}