import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hour_log/models/day.dart';
import 'package:hour_log/models/organization.dart';
import 'package:hour_log/models/user.dart';
import 'package:hour_log/shared/constants.dart';

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
      
        workDays.add(WorkDay.dayFromMap(workDayMap));
      }
    }

    List<String> orgs = List.from(snapshot.get('organizations'));

    UserData userData = UserData(
      uid, snapshot.get('name'), orgs, workDays
    );
    return userData;
  }

  Stream<List<Organization>> get allOrgs {

    return orgCollection.snapshots().map(_allOrgsFromSnapshot);
  }

  Stream<List<Organization>> get orgs {

    return orgCollection.snapshots().map(_orgsFromSnapshot);
  }

  List<Organization> _allOrgsFromSnapshot(QuerySnapshot snapshot){
    List<Organization> orgs = [];

    var queryDocs = snapshot.docs;
    
    for (var element in queryDocs) {
      List<UserData> members = [];
      String name = element['name'];
      String code = element.id;
      UserData owner = UserData.getUserDataFromMap(element['owner']);
      element['members'].forEach((member) => members.add(UserData.getUserDataFromMap(member)));

      orgs.add(Organization(name, code, members, owner));
    }
    return orgs;
  }

  List<Organization> _orgsFromSnapshot(QuerySnapshot snapshot){
    List<Organization> orgs = [];

    var queryDocs = snapshot.docs;
   
    for (var element in queryDocs) {
      List<UserData> members = [];
      String name = element['name'];
      String code = element.id;
      UserData owner = UserData.getUserDataFromMap(element['owner']);
      element['members'].forEach((member) => members.add(UserData.getUserDataFromMap(member)));
      
      Organization org = Organization(name, code, members, owner);
      if(org.owner.uid == uid){
        orgs.add(org);
      }
      else{
        for (var member in org.members) {
          if(member.uid == uid){
            orgs.add(org);
          }
        }
      }
    }
    return orgs;
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