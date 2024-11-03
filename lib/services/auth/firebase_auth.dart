import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:twitter_clone/services/databases/database_service.dart';

/*

- Login
- Register
- Logout
- Delete Account(required if you want to publish in app store)
*/

//get current user and user id

//login ->email and password

//register->email and password

//logout

// delete account

class AuthService {
  final auth = FirebaseAuth.instance;

  User? getcurrentuser() {
    return auth.currentUser;
  }

  String getcurrentuserid() {
    return auth.currentUser!.uid.toString();
  }

  Future<UserCredential?> login(String email, String password) async {
    try {
      final UserCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return UserCredential;
    } on FirebaseAuthException catch (e) {
      print(e.message);

      switch (e.code) {
        case 'user-not-found':
          print('user not found');
          break;

        case 'wrong-password':
          print('wrong password');
          break;

        default:
          print('an unknown error occured.');
      }
    }

    return null;
  }

  Future<void> deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser!;

    if (user != null) {
      await DatabaseService().deleteUserInfoFromFirebase(user.uid);
      await user.delete();
    }
  }

  // Future<UserCredential?> registerwithemailandpassword(
  //     String email, String password) async {
  //       final DatabaseService dbservice=DatabaseService();
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(email: email, password: password);
  //     await Future.delayed(Duration(seconds: 2));

  //     User? user=auth.currentUser;

  //     if(user!=null){
  //       final String uid=user.uid;
  //       await dbservice.saveUserInfoinFirebase(name: name, email: email)
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     print(e.message);
  //   }
  // }

  Future<void> logout() async {
    await auth.signOut();
  }
}
