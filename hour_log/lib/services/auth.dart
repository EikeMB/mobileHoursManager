




import 'package:firebase_auth/firebase_auth.dart';
import 'package:hour_log/models/day.dart';
import 'package:hour_log/models/user.dart';
import 'package:hour_log/shared/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser? _userFromFirebaseUser(User? user){
    return user != null ? AppUser(user.uid): null;
  }


  Stream<AppUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future signInEmail(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);

      User? user = result.user;

      createDatabaseService(user!.uid);

      return _userFromFirebaseUser(user);
    } catch(e){
      return null;
    }
  }

  Future signUpEmail(String username, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      User? user = result.user;

      createDatabaseService(user!.uid);

      await databaseService!.updateUserData(username, List<String>.empty(), List<WorkDay>.empty());

      return _userFromFirebaseUser(user);
    } catch(e){
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
      
    }
  }
}


