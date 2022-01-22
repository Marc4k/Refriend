import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:refriend/models/user.dart';
import 'package:refriend/database/database_user.dart';
import 'package:refriend/services/user_service.dart';

//the Service for Login and Register

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj based on FirebaseUser
  MyUser _userFromFirebaseUser(User user) {
    if (user != null) {
      return MyUser(uid: user.uid);
    } else {
      return null;
    }
  }

  //auth chance user stream
  Stream<MyUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(String email, String password,
      String name, DateTime birthday, File image) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      //upload the Profile pictures to the firestore
      await DatabaseServiceUser(uid: user.uid).uploadImageProfile(image);

      dynamic url_ = await UserService().getProfilPicture();

      String url = url_;
      //create a new document for the user with the ID
      await DatabaseServiceUser(uid: user.uid)
          .updateUserData(email, name, birthday, url);

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future resetEmail(String email) async {
    try {
      _auth.sendPasswordResetEmail(email: email);
      return "send";
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
