import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:refriend/constant/colors.dart';
import 'package:refriend/constant/size.dart';
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
  File _image;
  bool imagePicked = false;
  bool error = false;
  bool isLoading = false;
  //Pick your profil picture

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      final croppedImage = await ImageCropper().cropImage(
          androidUiSettings: AndroidUiSettings(
              statusBarColor: CustomColors.backgroundColor2,
              toolbarWidgetColor: CustomColors.custom_pink,
              activeControlsWidgetColor: CustomColors.custom_pink,
              toolbarColor: CustomColors.backgroundColor2),
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ]);

      if (croppedImage == null) return;

      final dir = await Directory.systemTemp;
      final tagetPath = dir.absolute.path + "/${image.name}.jpg";

      var resultImage = await FlutterImageCompress.compressAndGetFile(
          croppedImage.path, tagetPath,
          quality: 20);

      final imagetmp = File(resultImage.path);
      setState(() {
        _image = imagetmp;
        imagePicked = true;
      });
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.backgroundColor2,
        body: Column(
          children: [
            customWave(context),
            Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(getwidth(context) / 40, 0, 0, 0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      )),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Settings",
                    style: GoogleFonts.righteous(
                        color: CustomColors.fontColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                pickImage();
              },
              child: CircleAvatar(
                radius: getHeight(context) / 7.8,
                backgroundColor:
                    error ? CustomColors.custom_pink : Colors.transparent,
                child: CircleAvatar(
                    radius: getHeight(context) / 8,
                    backgroundImage: _image != null
                        ? FileImage(_image)
                        : AssetImage('assets/img/avatar.jpg'),
                    child: Icon(
                      Icons.edit,
                      color: CustomColors.fontColor,
                      size: getwidth(context) / 8,
                    )),
              ),
            ),
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
/*
            ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WelcomeScreen(),
                  ));
                },
                child: Text(
                  "Logout",
                )),*/