import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hour_log/models/day.dart';
import 'package:hour_log/models/organization.dart';
import 'package:hour_log/models/user.dart';

class DatabaseService{
  final String uid;
  final String code = '';
  DatabaseService(this.uid);


  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference orgCollection = FirebaseFirestore.instance.collection("organizations");

  Future updateUserData(String username, List<String> orgs, List<WorkDay> days) async {
    UserData data = UserData(uid, username, orgs, days);
    return await userCollection.doc(uid).set(data.getMapFromUserData());
  }

  Stream<UserData> get userData{
      return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    List<WorkDay> workDays = [];
    var workDaysFromSnapshot = snapshot.get('workdays') as List<dynamic>;
    for (var workDayMap in workDaysFromSnapshot) {
      if (workDayMap is Map<String, dynamic>) {
        DateTime startTime = DateTime.fromMillisecondsSinceEpoch(workDayMap['startTime']);
        DateTime endTime = DateTime.fromMillisecondsSinceEpoch(workDayMap['endTime']);
        Duration breakTime = Duration(milliseconds: workDayMap['breakTime']);
      
        workDays.add(WorkDay(startTime, endTime, breakTime));
      }
    }

    List<String> orgs = List.from(snapshot.get('organizations'));

    UserData userData = UserData(
      uid, snapshot.get('name'), orgs, workDays
    );
    return userData;
  }

  

  Future updateOrganizationData(String name, String code, List<UserData> members, UserData owner) async {
    Organization org = Organization(name, code, members, owner);

    List<Map> membersMaps = [];

    for(UserData member in members){
      membersMaps.add(member.getMapFromUserData());

    }

    

    try {
      return await orgCollection.doc(code).set({
      'name': name,
      'owner': owner.getMapFromUserData(),
      'members': membersMaps
    });
    } catch (e) {
      return null;
    }
  }

}