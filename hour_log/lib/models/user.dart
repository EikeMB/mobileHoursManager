import 'package:hour_log/models/day.dart';
import 'package:hour_log/models/organization.dart';

class AppUser{
  final String uid;

  AppUser(this.uid);
}


class UserData{
  final String uid;
  final String username;
  final List<Organization> orgs;
  final List<WorkDay> workDays;

  UserData(this.uid, this.username, this.orgs, this.workDays);
}