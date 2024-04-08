
import 'package:hour_log/models/user.dart';

class Organization {
  String name;
  String code;
  List<UserData> members;
  UserData owner;

  Organization(this.name, this.code, this.members, this.owner);
  
}