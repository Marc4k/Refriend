import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refriend/constant/colors.dart';
import 'package:refriend/constant/size.dart';
import 'package:refriend/services/chat_service.dart';
import 'package:refriend/widgets/ClipShadowPath.dart';
import 'package:flip_card/flip_card.dart';
import 'package:barcode_widget/barcode_widget.dart';

Widget customWave(BuildContext context) {
  return ClipShadowPath(
      clipper: WaveClipperTwo(),
      shadow: Shadow(blurRadius: 4),
      child: Container(
        child: Container(
          alignment: Alignment.centerLeft,
          width: double.infinity,
          color: CustomColors.backgroundColor2,
          height: getHeight(context) / 8,
          child: Column(
            children: [
              SizedBox(height: getwidth(context) / 17),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: getwidth(context) / 20),
                  Text(
                    "Refriend",
                    style: GoogleFonts.righteous(
                        color: CustomColors.fontColor,
                        fontSize: 30,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
}

Widget customWaveWithCustomText(BuildContext context, String text) {
  return ClipShadowPath(
      clipper: WaveClipperTwo(),
      shadow: Shadow(blurRadius: 4),
      child: Container(
        child: Container(
          alignment: Alignment.centerLeft,
          width: double.infinity,
          color: CustomColors.backgroundColor2,
          height: getHeight(context) / 8,
          child: Column(
            children: [
              SizedBox(height: getwidth(context) / 17),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: getwidth(context) / 15,
                      )),
                  Text(
                    "$text",
                    style: GoogleFonts.righteous(
                        color: CustomColors.fontColor,
                        fontSize: 30,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
}

Widget customWaveWithDots(BuildContext context) {
  return Stack(
    children: [
      ClipShadowPath(
          clipper: WaveClipperTwo(),
          shadow: Shadow(blurRadius: 4),
          child: Container(
            child: Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              color: CustomColors.backgroundColor2,
              height: getHeight(context) / 8,
              child: Column(
                children: [
                  SizedBox(height: getwidth(context) / 17),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: getwidth(context) / 20),
                      Text(
                        "Refriend",
                        style: GoogleFonts.righteous(
                            color: CustomColors.fontColor,
                            fontSize: 30,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
      Positioned(
          right: 5,
          top: 10,
          child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: CustomColors.fontColor,
                size: 40,
              )))
    ],
  );
}

Widget listViewItemForMainScreen(
    BuildContext context, String groupname, String imageURL) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(24, 15, 24, 15),
    child: Container(
      child: Row(
        children: [
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Row(
                children: [
                  SizedBox(width: getwidth(context) / 7),
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(3, 3), // changes position of shadow
                          ),
                        ],
                        color: CustomColors.backgroundColor2,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(5000),
                          topRight: Radius.circular(5000),
                        )),
                    padding: EdgeInsets.fromLTRB(
                        getwidth(context) / 6,
                        getwidth(context) / 40,
                        getwidth(context) / 6,
                        getwidth(context) / 40),
                    child: Text(
                      groupname,
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        color: CustomColors.fontColor,
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
                child: CircleAvatar(
                  radius: getwidth(context) / 10,
                  backgroundImage: NetworkImage(imageURL),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget emailField(String label, TextEditingController controller) {
  return TextFormField(
    validator: (value) {
      if (value.isNotEmpty && value.contains("@")) {
        return null;
      } else if (value.contains("@") && value.length < 2 && value.isNotEmpty) {
        return "Enter in the format: name@example.com";
      } else if (!value.contains("@") && value.isNotEmpty) {
        return "Enter in the format: name@example.com";
      } else {
        return "Please enter your email";
      }
    },
    controller: controller,
    cursorColor: CustomColors.fontColor,
    keyboardType: TextInputType.emailAddress,
    style: GoogleFonts.roboto(color: CustomColors.fontColor, fontSize: 20),
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      hintText: label,
      hintStyle: TextStyle(fontSize: 15, color: CustomColors.hintolor),
      errorStyle: TextStyle(color: CustomColors.custom_pink),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 1, color: CustomColors.fontColor),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 1, color: CustomColors.fontColor),
      ),
      labelStyle: TextStyle(fontSize: 16, color: CustomColors.fontColor),
      errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: CustomColors.custom_pink)),
      focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: CustomColors.custom_pink)),
    ),
  );
}

Widget passwordField(String label, TextEditingController controller) {
  bool _isObscure = false;

  return TextFormField(
    validator: (value) {
      if (value.isNotEmpty && value.length > 8) {
        return null;
      } else if (value.length < 8 && value.isNotEmpty) {
        return "Your password should be 8 letters long";
      } else {
        return "Please enter your Password";
      }
    },
    controller: controller,
    cursorColor: CustomColors.fontColor,
    obscureText: true,
    style: GoogleFonts.roboto(color: CustomColors.fontColor, fontSize: 20),
    decoration: InputDecoration(
      suffixIcon: IconButton(
        onPressed: () {
          _isObscure = !_isObscure;
        },
        icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
      ),
      border: OutlineInputBorder(),
      hintText: label,
      hintStyle: TextStyle(fontSize: 15, color: CustomColors.hintolor),
      errorStyle: TextStyle(color: CustomColors.custom_pink),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 1, color: CustomColors.fontColor),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 1, color: CustomColors.fontColor),
      ),
      labelStyle: TextStyle(fontSize: 16, color: CustomColors.fontColor),
      errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: CustomColors.custom_pink)),
      focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: CustomColors.custom_pink)),
    ),
  );
}

Widget nameField(String label, TextEditingController controller) {
  return TextFormField(
    validator: (value) {
      if (value.isNotEmpty) {
        return null;
      } else {
        return "Please enter your Name";
      }
    },
    controller: controller,
    cursorColor: CustomColors.fontColor,
    style: GoogleFonts.roboto(color: CustomColors.fontColor, fontSize: 20),
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      hintText: label,
      hintStyle: TextStyle(fontSize: 15, color: CustomColors.hintolor),
      errorStyle: TextStyle(color: CustomColors.custom_pink),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 1, color: CustomColors.fontColor),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 1, color: CustomColors.fontColor),
      ),
      labelStyle: TextStyle(fontSize: 16, color: CustomColors.fontColor),
      errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: CustomColors.custom_pink)),
      focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: CustomColors.custom_pink)),
    ),
  );
}

Widget eventcard(
    BuildContext context, String eventname, String location, String date) {
  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: FlipCard(
      fill: Fill
          .fillBack, // Fill the back side of the card to make in the same size as the front.
      direction: FlipDirection.HORIZONTAL, // default
      front: Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: getwidth(context) / 100),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("event.refriend")),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 2, 8),
                  child: SizedBox(
                    width: getwidth(context) / 10,
                    height: getHeight(context) / 5,
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: BarcodeWidget(
                          drawText: false,
                          data: eventname,
                          barcode: Barcode.code128()),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Refriend present:",
                        style: GoogleFonts.roboto(fontSize: 12)),
                    Text(eventname, style: GoogleFonts.roboto(fontSize: 18)),
                    SizedBox(height: getHeight(context) / 50),
                    Text("location", style: GoogleFonts.roboto(fontSize: 12)),
                    Text(location, style: GoogleFonts.roboto(fontSize: 18)),
                    SizedBox(height: getHeight(context) / 50),
                    Text(date, style: GoogleFonts.roboto(fontSize: 18)),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
      back: Container(
        color: Colors.white,
        child: Column(
          children: [
            Text("With"),
          ],
        ),
      ),
    ),
  );
}

Widget chatBubbleCustom(String name, String message, bool isSender,
    Timestamp createdAt, BuildContext context) {
  if (isSender == true) {
    return Row(
      children: [
        SizedBox(width: getwidth(context) / 4),
        Expanded(
          child: ChatBubble(
              elevation: 0,
              clipper: ChatBubbleClipper5(
                type: isSender
                    ? BubbleType.sendBubble
                    : BubbleType.receiverBubble,
              ),
              backGroundColor: Colors.white,
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message,
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    ChatService().formateDateToTimeOnly(createdAt),
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              )),
        ),
      ],
    );
  } else {
    return Row(
      children: [
        Expanded(
          child: ChatBubble(
              elevation: 0,
              clipper: ChatBubbleClipper5(
                type: isSender
                    ? BubbleType.sendBubble
                    : BubbleType.receiverBubble,
              ),
              backGroundColor: Colors.black26,
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(color: CustomColors.custom_pink),
                      ),
                      Text(
                        message,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),

                  Text(
                    ChatService().formateDateToTimeOnly(createdAt),
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  )

                  //  Text(message[index].name)
                ],
              )),
        ),
        SizedBox(width: getwidth(context) / 4),
      ],
    );
  }
}
