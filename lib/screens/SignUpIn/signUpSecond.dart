import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:refriend/constant/colors.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refriend/constant/size.dart';
import 'package:refriend/database/database_user.dart';
import 'package:refriend/screens/SignUpIn/signUpThird.dart';
import 'package:refriend/widgets/refriendCustomWidgets.dart';

class SignUpSecond extends StatefulWidget {
  final String name;
  final DateTime birthday;

  SignUpSecond({this.name, this.birthday});

  @override
  _SignUpSecondState createState() => _SignUpSecondState();
}

class _SignUpSecondState extends State<SignUpSecond> {
  double gapDividerBottom = 16;
  double gapDividerTop = 33;
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password1 = TextEditingController();
  final _password2 = TextEditingController();
  String error = "";

  bool first = false;
  bool second = false;
  bool third = false;

  bool _isObscure1 = true;
  bool _isObscure2 = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SafeArea(
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
                  SizedBox(height: getHeight(context) / gapDividerTop),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Almost finished!",
                        style: GoogleFonts.righteous(
                          textStyle: TextStyle(
                            color: CustomColors.maincolor,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: getHeight(context) / gapDividerTop),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "E-Mail",
                          style: GoogleFonts.roboto(
                              color: CustomColors.fontColor, fontSize: 20),
                        ),
                        emailField("Enter your E-Mail", _email),
                        SizedBox(height: getHeight(context) / 15),
                        Text(
                          "Password",
                          style: GoogleFonts.roboto(
                              color: CustomColors.fontColor, fontSize: 20),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isNotEmpty && value.length > 8) {
                              return null;
                            } else if (value.length < 8 && value.isNotEmpty) {
                              return "Your password should be 8 letters long";
                            } else {
                              return "Please enter your Password";
                            }
                          },
                          controller: _password1,
                          cursorColor: CustomColors.fontColor,
                          obscureText: _isObscure1,
                          style: GoogleFonts.roboto(
                              color: CustomColors.fontColor, fontSize: 20),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscure1 = !_isObscure1;
                                });
                              },
                              icon: Icon(
                                _isObscure1
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                            ),
                            border: OutlineInputBorder(),
                            hintText: "Enter your Password",
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
                        ),
                        SizedBox(height: getHeight(context) / 15),
                        Text(
                          "Repeate Password",
                          style: GoogleFonts.roboto(
                              color: CustomColors.fontColor, fontSize: 20),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isNotEmpty && value.length > 8) {
                              return null;
                            } else if (value.length < 8 && value.isNotEmpty) {
                              return "Your password should be 8 letters long";
                            } else {
                              return "Please enter your Password";
                            }
                          },
                          controller: _password2,
                          cursorColor: CustomColors.fontColor,
                          obscureText: _isObscure2,
                          style: GoogleFonts.roboto(
                              color: CustomColors.fontColor, fontSize: 20),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscure2 = !_isObscure2;
                                });
                              },
                              icon: Icon(
                                _isObscure2
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                            ),
                            border: OutlineInputBorder(),
                            hintText: "Enter your Password again",
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
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(error,
                          style: TextStyle(color: CustomColors.custom_pink)),
                    ),
                  ),
                  SizedBox(height: getHeight(context) / (gapDividerBottom + 2)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(
                            getHeight(context) / 10, getHeight(context) / 10),
                        primary: CustomColors.custom_pink,
                        elevation: 5,
                        shape: CircleBorder()),
                    onPressed: () async {
                      if (!_formKey.currentState.validate()) {
                        setState(() {
                          gapDividerTop = 50;
                          gapDividerBottom = 36;
                        });
                        return;
                      } else {
                        setState(() {
                          isLoading = true;
                        });

                        if (_password1.text != _password2.text) {
                          error = "Password is not the same";
                          _password2.clear();
                          _password1.clear();
                          isLoading = false;
                          return;
                        }
                        dynamic isEmailAlreadyInUse =
                            await DatabaseServiceUser().checkEmail(_email.text);
                        if (isEmailAlreadyInUse == true) {
                          setState(() {
                            error = "E-mail is already in use";
                            isLoading = false;
                            _email.clear();
                          });
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return SignUpThird(
                                name: widget.name,
                                birthday: widget.birthday,
                                email: _email.text,
                                password: _password1.text,
                              );
                            },
                          ));
                        }
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
                  SizedBox(height: getHeight(context) / gapDividerBottom),
                  Visibility(
                    visible: MediaQuery.of(context).viewInsets.bottom == 0,
                    child: DotsIndicator(
                      dotsCount: 3,
                      position: 1,
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
          ),
        ),
      ),
    );
  }
}
