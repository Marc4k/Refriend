import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:refriend/constant/colors.dart';
import 'package:refriend/constant/size.dart';
import 'package:refriend/cubit/userData_cubit.dart';
import 'package:refriend/cubit/profilPicture_cubit.dart.dart';
import 'package:refriend/database/database_user.dart';
import 'package:refriend/screens/SignUpIn/welcomeScreen.dart';
import 'package:refriend/services/user_service.dart';
import 'package:refriend/widgets/refriendCustomWidgets.dart';

class Settings extends StatefulWidget {
  String uid;

  Settings({this.uid});

  @override
  _SettingsState createState() => _SettingsState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _SettingsState extends State<Settings> {
  File _image;
  bool imagePicked = false;
  bool error = false;
  bool isLoading = false;

  final _name = TextEditingController();
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
            BlocBuilder<ProfilPicture, String>(
                builder: (context, profilPictureData) {
              if (profilPictureData.isEmpty) {
                return CircleAvatar(
                    radius: getHeight(context) / 7.8,
                    backgroundColor:
                        error ? CustomColors.custom_pink : Colors.transparent,
                    child: SpinKitChasingDots(
                      color: Colors.white,
                      size: 35,
                    ));
              } else {
                return GestureDetector(
                  onTap: () async {
                    await pickImage();

                    final User user = _auth.currentUser;
                    final uid = user.uid;
                    await DatabaseServiceUser(uid: uid)
                        .uploadImageProfile(_image);

                    dynamic url_ = await UserService().getProfilPicture();

                    await UserService().chanceProfilPicture(url_);
                  },
                  child: CircleAvatar(
                    radius: getHeight(context) / 7.8,
                    backgroundColor:
                        error ? CustomColors.custom_pink : Colors.transparent,
                    child: CircleAvatar(
                        radius: getHeight(context) / 8,
                        backgroundImage: _image != null
                            ? FileImage(_image)
                            : NetworkImage(profilPictureData),
                        child: Icon(
                          Icons.edit,
                          color: CustomColors.fontColor,
                          size: getwidth(context) / 8,
                        )),
                  ),
                );
              }
            }),
            BlocBuilder<GetUserName, String>(builder: (context, userName) {
              if (userName.isEmpty) {
                return Container();
              } else {
                return Padding(
                  padding: EdgeInsets.all(getwidth(context) / 20),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isNotEmpty) {
                        return null;
                      } else {
                        return "Please enter a new name";
                      }
                    },
                    controller: _name,
                    style: TextStyle(color: CustomColors.fontColor),
                    cursorColor: CustomColors.fontColor,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () async {
                            await UserService().chanceName(_name.text);
                          },
                          icon: Icon(
                            Icons.check,
                            color: Colors.white,
                          )),
                      border: OutlineInputBorder(),
                      hintText: userName,
                      hintStyle: TextStyle(color: CustomColors.fontColor),
                      errorStyle: TextStyle(color: CustomColors.custom_pink),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(17)),
                        borderSide:
                            BorderSide(width: 1, color: CustomColors.fontColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(17)),
                        borderSide:
                            BorderSide(width: 1, color: CustomColors.fontColor),
                      ),
                      labelStyle: TextStyle(
                          fontSize: 16, color: CustomColors.fontColor),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(17)),
                          borderSide: BorderSide(
                              width: 1, color: CustomColors.custom_pink)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(17)),
                          borderSide: BorderSide(
                              width: 1, color: CustomColors.custom_pink)),
                    ),
                  ),
                );
              }
            }),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white, primary: CustomColors.custom_pink),
                onPressed: () async {
                  await _auth.signOut();

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WelcomeScreen(),
                  ));
                },
                child: Text("Logout")),
          ],
        ),
      ),
    );
  }
}
//Please enter a new name