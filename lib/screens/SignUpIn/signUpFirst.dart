import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refriend/constant/colors.dart';
import 'package:refriend/constant/size.dart';
import 'package:refriend/screens/SignUpIn/signUpSecond.dart';
import 'package:refriend/widgets/refriendCustomWidgets.dart';

class SignUpFirst extends StatefulWidget {
  const SignUpFirst({Key key}) : super(key: key);

  @override
  _SignUpFirstState createState() => _SignUpFirstState();
}

class _SignUpFirstState extends State<SignUpFirst> {
  double gapDivider = 8;
  final _birthdaySingUp2 = TextEditingController();
  final _nickname = TextEditingController();
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: CustomColors.backgroundColor2,
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overScroll) {
              overScroll.disallowIndicator();
              return false;
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  customWave(context),
                  SizedBox(height: getHeight(context) / 25),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Let's get started!",
                        style: GoogleFonts.righteous(
                          textStyle: TextStyle(
                            color: CustomColors.maincolor,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: getHeight(context) / 25),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          style: GoogleFonts.roboto(
                              color: CustomColors.fontColor, fontSize: 20),
                        ),
                        nameField("Enter your Name", _nickname),
                        SizedBox(height: getHeight(context) / 15),
                        Text(
                          "Birthday",
                          style: GoogleFonts.roboto(
                              color: CustomColors.fontColor, fontSize: 20),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isNotEmpty) {
                              return null;
                            } else {
                              return "Please pick your birthday";
                            }
                          },
                          controller: _birthdaySingUp2,
                          cursorColor: CustomColors.fontColor,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.roboto(
                              color: CustomColors.fontColor, fontSize: 20),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Pick your birthday",
                            hintStyle: TextStyle(
                                fontSize: 15, color: CustomColors.hintolor),
                            errorStyle:
                                TextStyle(color: CustomColors.custom_pink),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: CustomColors.fontColor),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: CustomColors.fontColor),
                            ),
                            labelStyle: TextStyle(
                                fontSize: 16, color: CustomColors.fontColor),
                            errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: CustomColors.custom_pink)),
                            focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: CustomColors.custom_pink)),
                          ),
                          onTap: () async {
                            final DateTime picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                initialDatePickerMode: DatePickerMode.year,
                                firstDate: DateTime(1920, 8),
                                lastDate: DateTime(2101));

                            if (picked != null && picked != selectedDate)
                              setState(() {
                                selectedDate = picked;
                                String onlyDate =
                                    "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                                _birthdaySingUp2.text = onlyDate;
                              });
                          },
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/signIn");
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: "You’re already a member? ",
                                style: TextStyle(
                                    color: CustomColors.maincolor,
                                    fontSize: 15)),
                            TextSpan(
                                text: " Sign In",
                                style: TextStyle(
                                  color: CustomColors.custom_pink,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                )),
                          ]),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: getHeight(context) / gapDivider),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                              getHeight(context) / 10, getHeight(context) / 10),
                          primary: CustomColors.custom_pink,
                          elevation: 5,
                          shape: CircleBorder()),
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          setState(() {
                            gapDivider = 10;
                          });
                          return;
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return SignUpSecond(
                                name: _nickname.text,
                                birthday: selectedDate,
                              );
                            },
                          ));
                        }
                      },
                      child: Icon(
                        Icons.arrow_forward,
                        size: 50,
                      )),
                  SizedBox(height: getHeight(context) / gapDivider),
                  Visibility(
                    visible: MediaQuery.of(context).viewInsets.bottom == 0,
                    child: DotsIndicator(
                      dotsCount: 3,
                      position: 0,
                      decorator: DotsDecorator(
                        // Inactive color
                        activeColor: CustomColors.secondcolor_1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
