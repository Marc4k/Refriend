import 'package:flutter/material.dart';
import 'package:refriend/constant/colors.dart';
import 'package:refriend/screens/SingUpIN/welcomeScreen.dart';
import 'package:refriend/services/auth_service.dart';
import 'package:refriend/widgets/refriendCustomWidgets.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

AuthService _auth = AuthService();

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.backgroundColor2,
        body: Column(
          children: [
            customWave(context),
            ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WelcomeScreen(),
                  ));
                },
                child: Text(
                  "Logout",
                )),
          ],
        ),
      ),
    );
  }
}
