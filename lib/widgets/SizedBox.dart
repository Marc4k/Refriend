import 'package:flutter/material.dart';

Widget sizedBoxHeight(double percent, BuildContext context) {
  return SizedBox(height: MediaQuery.of(context).size.height * percent);
}

Widget sizedBoxWidght(double percent, BuildContext context) {
  return SizedBox(width: MediaQuery.of(context).size.width * percent);
}
