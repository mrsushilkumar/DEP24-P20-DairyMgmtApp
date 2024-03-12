import 'package:farm_expense_mangement_app/models/user.dart' as MyAppUser;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farm_expense_mangement_app/Services/database/userdatabase.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user object based on FirebaseUser
  MyAppUser.User? _userFromFirebaseUser(User? user) {
    return user != null ? MyAppUser.User(uid: user.uid) : null;
  }

  // Auth change user stream
  Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }

  // Sign in anonymously

  // Register with email and password

  Future<MyAppUser.User?> registerWithEmailAndPassword(String email, String password,String ownerName, String farmName,String location, int phoneNo) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      final farmUser = MyAppUser.FarmUser(ownerName: ownerName, farmName: farmName, location: location, phoneNo: phoneNo);
      await DatabaseServicesForUser(user!.uid).infoToServer(user.uid, farmUser);

      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
  Future<MyAppUser.User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
    }
  }
}
