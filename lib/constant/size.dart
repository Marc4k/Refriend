import 'package:flutter/material.dart';

double getHeight(BuildContext context) {
  double height = MediaQuery.of(context).size.height;
  return height;
}

double getwidth(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  return width;
}
