import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:refriend/database/database_user.dart';

class NotifactionTest extends StatefulWidget {
  const NotifactionTest({Key key}) : super(key: key);

  @override
  State<NotifactionTest> createState() => _NotifactionTestState();
}

class _NotifactionTestState extends State<NotifactionTest> {
  FirebaseMessaging _fcm = FirebaseMessaging.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onLaunch: $message");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published! $message');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                DatabaseServiceUser().getNotificationToken();
              },
              child: Text("Hallo"))
        ],
      ),
    );
  }
}
