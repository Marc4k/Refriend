import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/src/provider.dart';
import 'package:refriend/constant/colors.dart';
import 'package:refriend/constant/size.dart';
import 'package:refriend/cubit/groupList_cubit.dart';
import 'package:refriend/services/auth_service.dart';
import 'package:refriend/database/database_user.dart';
import 'package:refriend/services/group_service.dart';
import 'package:refriend/services/user_service.dart';
import 'package:refriend/widgets/custom_widgets.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key key}) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  File _image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imagetmp = File(image.path);
      setState(() {
        _image = imagetmp;
      });
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  AuthService _auth = AuthService();
  UserService _user_service = UserService();
  GroupService _group_service = GroupService();
  String error = "";
  String inviteCode = "";
  final _inviteCodeController = TextEditingController();
  bool isCreate = false;
  final _groupname = TextEditingController();
  final _groupDesc = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor2,
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundColor2,
        title: Text("Create new Group"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      print("Edit");
                      pickImage();
                    },
                    child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _image != null
                            ? FileImage(_image)
                            : AssetImage('assets/img/avatar.jpg'),
                        child: Icon(
                          Icons.edit,
                          color: CustomColors.backgroundColor,
                        )),
                  ),
                  SizedBox(height: getHeight(context) / 25),
                  Expanded(
                      child: customTextfield("Group Name", _groupname, 1, 1)),
                ],
              ),
              SizedBox(height: getHeight(context) / 25),
              customTextfieldWithMaxLenght(
                  "Description", _groupDesc, 3, 3, 125),
              Text("$error",
                  style: TextStyle(color: CustomColors.secondcolor_1)),
              SizedBox(height: getHeight(context) / 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(100, 10, 100, 10),
                    primary: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27.0),
                    )),
                onPressed: () async {
                  //Gruppe erstellen
                  dynamic inviteCodeDy =
                      await _group_service.createGroupAndInvite(
                          _groupname.text, _groupDesc.text, _image);
                  _groupDesc.clear();
                  _groupname.clear();
                  //Gruppen Code ausgeben
                  setState(() {
                    inviteCode = inviteCodeDy;
                  });
                },
                child: GradientText(
                  "Create",
                  style:
                      GoogleFonts.righteous(textStyle: TextStyle(fontSize: 30)),
                  colors: [
                    CustomColors.secondcolor_1,
                    CustomColors.secondcolor_2,
                  ],
                ),
              ),
              SizedBox(height: getHeight(context) / 25),
              Text(
                "Groupe Code: $inviteCode",
                style: GoogleFonts.righteous(
                  textStyle: TextStyle(
                    color: CustomColors.maincolor,
                    fontSize: 35,
                  ),
                ),
              ),
              SizedBox(height: getHeight(context) / 25),
            ],
          ),
        ),
      ),
    );
  }
}
