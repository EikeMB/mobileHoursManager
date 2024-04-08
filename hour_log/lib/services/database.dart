import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hour_log/models/day.dart';
import 'package:hour_log/models/organization.dart';
import 'package:hour_log/models/user.dart';

class DatabaseService{
  final String uid;
  DatabaseService(this.uid);


  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference orgCollection = FirebaseFirestore.instance.collection("organizations");

  Future updateUserData(String username, List<Organization> orgs, List<WorkDay> days) async {
    return await userCollection.doc(uid).set({
      'username': username,
      'orgs': orgs,
      'hours': days
    });
  }

  Stream<UserData> get userData{
      return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid, snapshot.get('username'), snapshot.get('orgs'), snapshot.get('workDays')
    );
  }

  Future updateOrganizationData(String name, String code, List<AppUser> members, AppUser owner) async {
    return await orgCollection.doc(code).set({
      'name': name,
      'members': members,
      'owner': owner
    });
  }

}