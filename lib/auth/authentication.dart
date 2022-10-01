import 'dart:async';
import 'package:dalu_potha/auth/model/busines_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../database.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DataRepository repository = DataRepository();
  get user => _auth.currentUser;

  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();
    print('signout');
  }

  Future signUpBusiness(
      String email,
      String password,
      String ownerName,
      String businessName,
      String businessPhoneNo,
      String businessAddress) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> getCurrentUser() async {
    User user = _auth.currentUser!;
    return user.email.toString();
  }
}

// Future<void> sendEmailVerification() async {
//   FirebaseUser user = await _firebaseAuth.currentUser();
//   user.sendEmailVerification();
// }
//
// Future<bool> isEmailVerified() async {
//   FirebaseUser user = await _firebaseAuth.currentUser();
//   return user.isEmailVerified;
// }
//
// @override
// Future<void> changeEmail(String email) async {
//   FirebaseUser user = await _firebaseAuth.currentUser();
//   user.updateEmail(email).then((_) {
//     print("Succesfull changed email");
//   }).catchError((error) {
//     print("email can't be changed" + error.toString());
//   });
//   return null;
// }
//
// @override
// Future<void> changePassword(String password) async {
//   FirebaseUser user = await _firebaseAuth.currentUser();
//   user.updatePassword(password).then((_) {
//     print("Succesfull changed password");
//   }).catchError((error) {
//     print("Password can't be changed" + error.toString());
//   });
//   return null;
// }
//
// @override
// Future<void> deleteUser() async {
//   FirebaseUser user = await _firebaseAuth.currentUser();
//   user.delete().then((_) {
//     print("Succesfull user deleted");
//   }).catchError((error) {
//     print("user can't be delete" + error.toString());
//   });
//   return null;
// }
//
// @override
// Future<void> sendPasswordResetMail(String email) async {
//   await _firebaseAuth.sendPasswordResetEmail(email: email);
//   return null;
// }
