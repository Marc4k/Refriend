import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refriend/constant/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            //* Picture of the grop
            Container(
              alignment: Alignment.topCenter,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                "assets/img/background2.jpg",
                fit: BoxFit.fitWidth,
              ),
            ),

            //* the container with the text and buttons
            Positioned(
              child: Container(
                  height: MediaQuery.of(context).size.height / 2.3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: CustomColors.backgroundColor2,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(flex: 2),
                      Text(
                        "Welcome to Refriend",
                        style: GoogleFonts.righteous(
                          textStyle: TextStyle(
                            color: CustomColors.maincolor,
                            fontSize: 35,
                          ),
                        ),
                      ),
                      Spacer(flex: 2),
                      Text(
                        "Organize events with friends",
                        style: GoogleFonts.publicSans(
                          textStyle: TextStyle(
                            color: CustomColors.maincolor,
                            fontSize: 23,
                          ),
                        ),
                      ),
                      Text(
                        "and family easily and clearly.",
                        style: GoogleFonts.publicSans(
                          textStyle: TextStyle(
                            color: CustomColors.maincolor,
                            fontSize: 23,
                          ),
                        ),
                      ),
                      Spacer(flex: 2),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                            primary: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(27.0),
                            )),
                        onPressed: () {
                          Navigator.pushNamed(context, "/signUpFirst");
                        },
                        child: GradientText(
                          "Sign up",
                          style: GoogleFonts.righteous(
                              textStyle: TextStyle(fontSize: 30)),
                          colors: [
                            CustomColors.secondcolor_1,
                            CustomColors.secondcolor_2,
                          ],
                        ),
                      ),
                      Spacer(flex: 1),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/signIn");
                        },
                        child: RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: "You’re already a member?",
                                style: TextStyle(
                                    color: CustomColors.maincolor,
                                    fontSize: 15)),
                            TextSpan(
                                text: " Login",
                                style: TextStyle(
                                  color: CustomColors.secondcolor_1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                )),
                          ]),
                        ),
                      ),
                      Spacer(flex: 5),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
