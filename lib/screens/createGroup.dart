import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:refriend/constant/colors.dart';
import 'package:refriend/constant/size.dart';
import 'package:refriend/services/group_service.dart';
import 'package:refriend/widgets/custom_widgets.dart';
import 'package:refriend/widgets/refriendCustomWidgets.dart';
import 'package:share/share.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key key}) : super(key: key);

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

GroupService _group_service = GroupService();

final _groupName = TextEditingController();
final _description = TextEditingController();
String inviteCode = "";
File _image;
bool shareButton = false;
bool imagePicked = false;
bool error_image = false;
bool error_text = false;
bool isLoading = false;

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      final croppedImage = await ImageCropper.cropImage(
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
        error_image = false;
      });
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor2,
      body: SafeArea(
          child: Column(
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
                        shareButton = false;
                        inviteCode = "";

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
                  "Create a group",
                  style: GoogleFonts.righteous(
                      color: CustomColors.fontColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
          SizedBox(height: getHeight(context) / 20),
          Container(
            child: Row(
              children: [
                SizedBox(width: getwidth(context) / 10),
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: getwidth(context) / 7),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: error_text
                                      ? CustomColors.custom_pink
                                      : Colors.white),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(
                                      3, 3), // changes position of shadow
                                ),
                              ],
                              color: CustomColors.backgroundColor2,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(5000),
                                topRight: Radius.circular(5000),
                              )),
                          padding: EdgeInsets.fromLTRB(
                              getwidth(context) / 12,
                              getwidth(context) / 40,
                              getwidth(context) / 40,
                              getwidth(context) / 40),
                          child: SizedBox(
                            height: getwidth(context) / 15,
                            width: getwidth(context) / 2.8,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  setState(() {
                                    error_text = false;
                                  });
                                }
                              },
                              controller: _groupName,
                              maxLength: 12,
                              cursorColor: CustomColors.fontColor,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: CustomColors.fontColor),
                              decoration: InputDecoration(
                                counterText: "",
                                counterStyle:
                                    TextStyle(color: CustomColors.fontColor),
                                fillColor: Colors.transparent,
                                hintText: "Group Name",
                                hintStyle: TextStyle(
                                    fontSize: 12, color: Colors.white),
                                filled: true,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(500000)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(3, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          pickImage();
                        },
                        child: CircleAvatar(
                          backgroundColor: error_image
                              ? CustomColors.custom_pink
                              : Colors.transparent,
                          radius: getwidth(context) / 8.5,
                          child: CircleAvatar(
                              backgroundImage: _image != null
                                  ? FileImage(_image)
                                  : AssetImage('assets/img/avatar.jpg'),
                              backgroundColor: Colors.white,
                              radius: getwidth(context) / 8.7,
                              child: Icon(
                                Icons.edit,
                                color: Colors.black,
                                size: getwidth(context) / 12,
                              )
                              //backgroundImage: NetworkImage(imageURL),
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                getwidth(context) / 10,
                getwidth(context) / 20,
                getwidth(context) / 10,
                getwidth(context) / 20),
            child: customTextfield("Description", _description, 5, 5),
          ),
          Text(
            "Group Code:",
            style: GoogleFonts.righteous(
                color: CustomColors.fontColor,
                fontSize: 25,
                fontWeight: FontWeight.w400),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                inviteCode,
                style: GoogleFonts.righteous(
                    color: CustomColors.fontColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w400),
              ),
              Visibility(
                visible: shareButton,
                child: IconButton(
                    onPressed: () => Share.share(
                        'Join my group on Refriend. Code: $inviteCode'),
                    icon: Icon(
                      Icons.share,
                      color: Colors.white,
                    )),
              )
            ],
          ),
          Spacer(flex: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize:
                    Size(getHeight(context) / 10, getHeight(context) / 10),
                primary: CustomColors.custom_pink,
                elevation: 5,
                shape: CircleBorder()),
            onPressed: () async {
              if (imagePicked == false) {
                setState(() {
                  error_image = true;
                });
              }
              if (_groupName.text.isEmpty) {
                setState(() {
                  error_text = true;
                });
              }

              if (imagePicked == true && error_text == false) {
                setState(() {
                  isLoading = true;
                });

                String description = "";
                if (_description.text.isNotEmpty) {
                  description = _description.text;
                }

                dynamic inviteCodeDy = await _group_service
                    .createGroupAndInvite(_groupName.text, description, _image);
                _groupName.clear();
                _description.clear();
                //Gruppen Code ausgeben
                setState(() {
                  isLoading = false;
                  inviteCode = inviteCodeDy;
                  shareButton = true;
                });
              }
            },
            child: isLoading
                ? SpinKitWave(
                    color: Colors.white,
                    size: 15,
                  )
                : Icon(
                    Icons.check,
                    size: 50,
                  ),
          ),
          Spacer(flex: 4),
        ],
      )),
    );
  }
}
