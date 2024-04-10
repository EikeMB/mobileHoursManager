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
        String org = workDayMap['organization'];
        DateTime startTime = DateTime.fromMillisecondsSinceEpoch(workDayMap['startTime']);
        DateTime endTime = DateTime.fromMillisecondsSinceEpoch(workDayMap['endTime']);
        Duration breakTime = Duration(milliseconds: workDayMap['breakTime']);
      
        workDays.add(WorkDay(org, startTime, endTime, breakTime));
      }
    }

    List<String> orgs = List.from(snapshot.get('organizations'));

    UserData userData = UserData(
      uid, snapshot.get('name'), orgs, workDays
    );
    return userData;
  }

  Stream<List<Organization>> get orgs {

    return orgCollection.snapshots().map(_orgsFromSnapshot);
  }

  List<Organization> _orgsFromSnapshot(QuerySnapshot snapshot){
    List<Organization> orgs = [];
    List<Organization> userOrgs = [];

    var queryDocs = snapshot.docs;
    List<UserData> members = [];
    for (var element in queryDocs) {
      String name = element['name'];
      String code = element.id;
      UserData owner = UserData.getUserDataFromMap(element['owner']);
      element['members'].forEach((member) => members.add(UserData.getUserDataFromMap(member)));

      orgs.add(Organization(name, code, members, owner));
    }
    for (var org in orgs) {
      if(org.owner.uid == uid){
        userOrgs.add(org);
      }
      else{
        for (var member in org.members) {
          if(member.uid == uid){
            userOrgs.add(org);
          }
        }
      }

    }
    return userOrgs;
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