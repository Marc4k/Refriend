//! Checked 12:21 04.01.2022

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refriend/constant/colors.dart';
import 'package:refriend/constant/size.dart';
import 'package:refriend/cubit/groupList_cubit.dart';
import 'package:refriend/cubit/profilPicture_cubit.dart.dart';
import 'package:refriend/screens/home.dart';
import 'package:refriend/services/auth_service.dart';
import 'package:refriend/widgets/custom_widgets.dart';
import 'package:refriend/widgets/refriendCustomWidgets.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:dots_indicator/dots_indicator.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String error;

  final _emailSignIn = TextEditingController();
  final _passwordSignIn = TextEditingController();
  bool isLoading = false;
  bool isLoadingResetPassword = false;

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
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Welcome back. ",
                            style: GoogleFonts.righteous(
                              textStyle: TextStyle(
                                color: CustomColors.maincolor,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "You’ve been missed!",
                            style: GoogleFonts.righteous(
                              textStyle: TextStyle(
                                color: CustomColors.maincolor,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: getHeight(context) / 25),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "E-Mail",
                          style: GoogleFonts.roboto(
                              color: CustomColors.fontColor, fontSize: 20),
                        ),
                        emailField("Enter your E-Mail", _emailSignIn),
                        SizedBox(height: getHeight(context) / 15),
                        Text(
                          "Password",
                          style: GoogleFonts.roboto(
                              color: CustomColors.fontColor, fontSize: 20),
                        ),
                        passwordField("Enter your Password", _passwordSignIn),
                        SizedBox(height: getHeight(context) / 50),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(20)),
                                ),
                                backgroundColor: CustomColors.backgroundColor2,
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.40,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    35),
                                            Text(
                                              "Reset your Password",
                                              style: GoogleFonts.righteous(
                                                textStyle: TextStyle(
                                                  color: CustomColors.maincolor,
                                                  fontSize: 25,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    25),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        25, 0, 25, 0),
                                                child: Text(
                                                  "E-Mail",
                                                  style: GoogleFonts.roboto(
                                                      color: CustomColors
                                                          .fontColor,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      25, 5, 25, 5),
                                              child: emailField(
                                                  "Enter your E-Mail",
                                                  _emailSignIn),
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    20),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  fixedSize: Size(
                                                      getHeight(context) / 10,
                                                      getHeight(context) / 10),
                                                  primary:
                                                      CustomColors.custom_pink,
                                                  elevation: 5,
                                                  shape: CircleBorder()),
                                              onPressed: () async {
                                                setState(() {
                                                  isLoadingResetPassword = true;
                                                });

                                                dynamic result =
                                                    await _auth.resetEmail(
                                                        _emailSignIn.text);

                                                if (result != "") {
                                                  print("Email Send");
                                                  isLoadingResetPassword =
                                                      false;
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: isLoadingResetPassword
                                                  ? SpinKitWave(
                                                      color: Colors.white,
                                                      size: 15,
                                                    )
                                                  : Icon(
                                                      Icons.check,
                                                      size: 50,
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Forgot your password?",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: CustomColors.maincolor),
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: getHeight(context) / 10),
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

                        dynamic result = await _auth.signInWithEmailAndPassword(
                            _emailSignIn.text, _passwordSignIn.text);
                        if (result == null) {
                          setState(() {
                            error = "The email or the password is wrong.";
                            setState(() {
                              isLoading = false;
                            });
                          });
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider<GroupDataCubit>(
                                          create: (context) => GroupDataCubit()
                                            ..getYourGroups()),
                                    ],
                                    child: Homescreen(),
                                  )));
                        }
                        setState(() {
                          isLoading = false;
                          _emailSignIn.clear();
                          _passwordSignIn.clear();
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
                  SizedBox(height: getHeight(context) / 10),
                  Visibility(
                    visible: MediaQuery.of(context).viewInsets.bottom == 0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/signUpFirst");
                      },
                      child: RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                  color: CustomColors.maincolor, fontSize: 15)),
                          TextSpan(
                              text: " Sign Up",
                              style: TextStyle(
                                color: CustomColors.custom_pink,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                        ]),
                      ),
                    ),
                  ),
                  SizedBox(height: getHeight(context) / 70)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
