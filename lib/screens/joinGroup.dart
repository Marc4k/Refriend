import 'package:flutter/material.dart';
import 'package:refriend/constant/colors.dart';
import 'package:refriend/services/auth_service.dart';
import 'package:refriend/services/group_service.dart';
import 'package:refriend/services/user_service.dart';
import 'package:refriend/widgets/custom_widgets.dart';
import 'package:refriend/widgets/refriendCustomWidgets.dart';

class JoinGroup extends StatefulWidget {
  const JoinGroup({Key key}) : super(key: key);

  @override
  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  AuthService _auth = AuthService();
  UserService _user_service = UserService();
  GroupService _group_service = GroupService();
  final _inviteCodeController = TextEditingController();
  String error = "";
  String inviteCode = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor2,
      body: SafeArea(
          child: Column(
        children: [
          customWave(
            context,
          ),
          nameTextfield("Invite Code", _inviteCodeController),
          ElevatedButton(
              onPressed: () async {
                dynamic result =
                    await _group_service.joinGroup(_inviteCodeController.text);
                if (result == null) {
                  setState(() {
                    error = "The Code is not valid!";
                    _inviteCodeController.clear();
                  });
                }
                if (result == true) {
                  _inviteCodeController.clear();
                  setState(() {
                    error = "";
                  });
                }
              },
              child: Text(
                "Join Group",
              )),
        ],
      )),
    );
  }
}
