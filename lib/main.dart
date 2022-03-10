//! Checked
//Imports
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refriend/models/user.dart';
import 'package:refriend/screens/createEvent.dart';
import 'package:refriend/screens/createGroup.dart';
import 'package:refriend/screens/group_chat/group_bigView.dart';
import 'package:refriend/screens/SignUpIn/signIn.dart';
import 'package:refriend/screens/SignUpIn/signUpFirst.dart';
import 'package:refriend/screens/SignUpIn/signUpSecond.dart';
import 'package:refriend/screens/SignUpIn/signUpThird.dart';
import 'package:refriend/screens/home.dart';
import 'package:refriend/screens/settings.dart';
import 'package:refriend/services/auth_service.dart';
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
          "/createGroup": (context) => CreateGroupScreen(),
          "/groupEventBig": (context) => GroupEventBigView(),
          "/homescreen": (context) => Homescreen(),
          "/settings": (context) => Settings(),
          "/createEvent": (context) => CreateEvent(),
        },
      ),
    );
  }
}
