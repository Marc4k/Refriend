import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:refriend/models/groupMembers.dart';

//the Databse for the user functions

class DatabaseServiceUser {
  final String uid;

  DatabaseServiceUser({this.uid});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference userData =
      FirebaseFirestore.instance.collection('userData');

  //create or update a user Document
  Future updateUserData(String email, String name, DateTime birthday,
      String profilPictureUrl) async {
    return await userData.doc(uid).set({
      "name": name,
      "birthday": birthday,
      "email": email,
      "userid": uid,
      "url": profilPictureUrl,
    });
  }

  //upload profile picture to the cloud firestore
  Future uploadImageProfile(File image) async {
    final destination = "Profil/$uid/profil.png";
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      await ref.putFile(image);
      return destination;
    } on FirebaseException catch (e) {
      return null;
    }
  }

  //check if the email is already in use
  Future checkEmail(String email) async {
    bool isSame = false;

    try {
      await userData.get().then((snapshot) {
        snapshot.docs.forEach((element) {
          Map<String, dynamic> data = element.data();
          if (data["email"] == email) {
            isSame = true;
          }
        });
      });
    } catch (e) {
      return null;
    }
    return isSame;
  }

  //return the userData
  Future getUserInfos(String userID) async {
    Map userDataFromDatabse;

    try {
      await userData.get().then((snapshot) {
        snapshot.docs.forEach((element) {
          Map<String, dynamic> data = element.data();
          if (data["userid"] == userID) {
            userDataFromDatabse = data;
          }
        });
      });
    } catch (e) {
      return null;
    }
    return userDataFromDatabse;
  }

  Future getUserProfilUrl(String userID) async {
    String url;

    try {
      await userData.get().then((snapshot) {
        snapshot.docs.forEach((element) {
          Map<String, dynamic> data = element.data();
          if (data["userid"] == userID) {
            url = data["url"];
          }
        });
      });
    } catch (e) {
      return null;
    }
    return url;
  }

  Future getNotificationToken() async {
    String token = await FirebaseMessaging.instance.getToken();

    print(token);
  }
}
