import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:refriend/constant/colors.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refriend/constant/size.dart';
import 'package:refriend/cubit/groupList_cubit.dart';
import 'package:refriend/cubit/homeLoading_cubit.dart';
import 'package:refriend/screens/home.dart';
import 'package:refriend/services/auth_service.dart';
import 'package:refriend/widgets/refriendCustomWidgets.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SignUpThird extends StatefulWidget {
  final String name;
  final DateTime birthday;
  final String email;
  final String password;

  SignUpThird({this.name, this.birthday, this.email, this.password});

  @override
  _SignUpThirdState createState() => _SignUpThirdState();
}

final AuthService _auth = AuthService();

class _SignUpThirdState extends State<SignUpThird> {
  File _image;
  bool imagePicked = false;
  bool error = false;
  bool isLoading = false;
  //Pick your profil picture

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      final croppedImage = await ImageCropper().cropImage(
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
    final _nickname = TextEditingController();
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.backgroundColor2,
        body: Column(
          children: [
            customWave(context),
            SizedBox(height: getHeight(context) / 25),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Upload your picture",
                style: GoogleFonts.righteous(
                  textStyle: TextStyle(
                    color: CustomColors.maincolor,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            SizedBox(height: getHeight(context) / 15),
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
            SizedBox(height: getHeight(context) / 8),
            Visibility(
              visible: MediaQuery.of(context).viewInsets.bottom == 0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize:
                        Size(getHeight(context) / 10, getHeight(context) / 10),
                    primary: CustomColors.custom_pink,
                    elevation: 5,
                    shape: CircleBorder()),
                onPressed: () async {
                  if (imagePicked == true) {
                    setState(() {
                      error = false;
                      isLoading = true;
                    });
                    dynamic result = await _auth.registerWithEmailAndPassword(
                        widget.email,
                        widget.password,
                        widget.name,
                        widget.birthday,
                        _image);

                    setState(() {
                      error = false;
                      isLoading = false;
                    });
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider<HomeLoading>(
                                  create: (BuildContext context) =>
                                      HomeLoading()..getDataComplete(),
                                ),
                                BlocProvider<GroupDataCubit>(
                                  create: (BuildContext context) =>
                                      GroupDataCubit()..getYourGroups(),
                                ),
                              ],
                              child: Homescreen(),
                            )));
                  } else {
                    setState(() {
                      error = true;
                    });
                  }
                },
                child: isLoading
                    ? SpinKitWave(
                        color: Colors.white,
                        size: 15,
                      )
                    : Icon(
                        Icons.arrow_forward,
                        size: 50,
                      ),
              ),
            ),
            SizedBox(height: getHeight(context) / 5.8),
            Visibility(
              visible: MediaQuery.of(context).viewInsets.bottom == 0,
              child: DotsIndicator(
                dotsCount: 3,
                position: 2,
                decorator: DotsDecorator(
                  // Inactive color
                  activeColor: CustomColors.secondcolor_1,
                ),
              ),
            ),
            SizedBox(height: getHeight(context) / 100),
          ],
        ),
      ),
    );
  }
}
