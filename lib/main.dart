//! Checked
//Imports
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refriend/models/user.dart';
import 'package:refriend/notificationTest.dart';

import 'package:refriend/screens/group_chat/groupEventChat.dart';

import 'package:refriend/screens/group_chat/group_bigView.dart';

import 'package:refriend/screens/createGroup.dart';
import 'package:refriend/screens/SingUpIN/signIn.dart';
import 'package:refriend/screens/SingUpIN/signUpFirst.dart';
import 'package:refriend/screens/SingUpIN/signUpSecond.dart';
import 'package:refriend/screens/SingUpIN/signUpThird.dart';
import 'package:refriend/screens/SingUpIN/welcomeScreen.dart';
import 'package:refriend/screens/home.dart';
import 'package:refriend/screens/joinGroup.dart';
import 'package:refriend/screens/settings.dart';
import 'package:refriend/services/auth_service.dart';
import 'package:refriend/test.dart';

import 'package:refriend/wrapper.dart';

void main() async {
  //Initialize Firebase for the App
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        home: Wrapper(),
        routes: {
          "/signIn": (context) => SignIn(),
          "/signUpFirst": (context) => SignUpFirst(),
          "/signUpSecond": (context) => SignUpSecond(),
          "/signUpThird": (context) => SignUpThird(),
          "/createGroup": (context) => CreateGroup(),
          "/groupEventBig": (context) => GroupEventBigView(),
          "/homescreen": (context) => Homescreen(),
          "/settings": (context) => Settings(),
          "/joinGroup": (context) => JoinGroup(),
        },
      ),
    );
  }
}
