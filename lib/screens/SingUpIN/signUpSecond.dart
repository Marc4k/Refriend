import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:refriend/constant/colors.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refriend/constant/size.dart';
import 'package:refriend/database/database_user.dart';
import 'package:refriend/screens/SingUpIN/signUpThird.dart';
import 'package:refriend/widgets/refriendCustomWidgets.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SignUpSecond extends StatefulWidget {
  final String name;
  final DateTime birthday;

  SignUpSecond({this.name, this.birthday});

  @override
  _SignUpSecondState createState() => _SignUpSecondState();
}

class _SignUpSecondState extends State<SignUpSecond> {
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password1 = TextEditingController();
  final _password2 = TextEditingController();
  String error = "";

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
                  SizedBox(height: getHeight(context) / 25),
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
                  SizedBox(height: getHeight(context) / 25),
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
                        passwordField("Enter your Password", _password1),
                        SizedBox(height: getHeight(context) / 15),
                        Text(
                          "Repeate Password",
                          style: GoogleFonts.roboto(
                              color: CustomColors.fontColor, fontSize: 20),
                        ),
                        passwordField("Enter your Password again", _password2),
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
                  SizedBox(height: getHeight(context) / 18),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(
                            getHeight(context) / 10, getHeight(context) / 10),
                        primary: CustomColors.custom_pink,
                        elevation: 5,
                        shape: CircleBorder()),
                    onPressed: () async {
                      if (!_formKey.currentState.validate()) {
                        return;
                      } else {
                        setState(() {
                          isLoading = true;
                        });
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
                  SizedBox(height: getHeight(context) / 16),
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
