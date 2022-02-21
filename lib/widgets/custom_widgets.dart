import 'package:flutter/material.dart';
import 'package:refriend/constant/colors.dart';

Widget usernameTextfield(String label, TextEditingController controller) {
  return TextFormField(
    validator: (value) {
      if (value.isNotEmpty && value.length > 2) {
        return null;
      } else if (value.length < 3 && value.isNotEmpty) {
        return "Your username can't be that short";
      } else {
        return "Please enter your username";
      }
    },
    controller: controller,
    style: TextStyle(color: CustomColors.fontColor),
    cursorColor: CustomColors.fontColor,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: '$label',
      errorStyle: TextStyle(color: CustomColors.custom_pink),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(11)),
        borderSide: BorderSide(width: 1, color: CustomColors.fontColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(11)),
        borderSide: BorderSide(width: 1, color: CustomColors.fontColor),
      ),
      labelStyle: TextStyle(fontSize: 16, color: CustomColors.fontColor),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(11)),
          borderSide: BorderSide(width: 1, color: CustomColors.custom_pink)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(11)),
          borderSide: BorderSide(width: 1, color: CustomColors.custom_pink)),
    ),
  );
}

Widget nameTextfield(String label, TextEditingController controller) {
  return TextFormField(
    validator: (value) {
      if (value.isNotEmpty && value.length > 2) {
        return null;
      } else if (value.length < 3 && value.isNotEmpty) {
        return "Now way your name is that short";
      } else {
        return "Please enter your name";
      }
    },
    controller: controller,
    style: TextStyle(color: CustomColors.fontColor),
    cursorColor: CustomColors.fontColor,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: '$label',
      errorStyle: TextStyle(color: CustomColors.custom_pink),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        borderSide: BorderSide(width: 2, color: CustomColors.fontColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        borderSide: BorderSide(width: 2, color: CustomColors.fontColor),
      ),
      labelStyle: TextStyle(fontSize: 16, color: CustomColors.fontColor),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(width: 2, color: CustomColors.custom_pink)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(width: 2, color: CustomColors.custom_pink)),
    ),
  );
}

Widget emailTextfield(String label, TextEditingController controller) {
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
    keyboardType: TextInputType.emailAddress,
    style: TextStyle(color: CustomColors.fontColor),
    cursorColor: CustomColors.fontColor,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: '$label',
      errorStyle: TextStyle(color: CustomColors.secondcolor_1),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        borderSide: BorderSide(width: 2, color: CustomColors.fontColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        borderSide: BorderSide(width: 2, color: CustomColors.fontColor),
      ),
      labelStyle: TextStyle(fontSize: 16, color: CustomColors.fontColor),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(width: 2, color: CustomColors.secondcolor_1)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(width: 2, color: CustomColors.secondcolor_1)),
    ),
  );
}

Widget passwordTextfield(String label, TextEditingController controller) {
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
    style: TextStyle(color: CustomColors.fontColor),
    cursorColor: CustomColors.fontColor,
    obscureText: true,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: '$label',
      errorStyle: TextStyle(color: CustomColors.custom_pink),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        borderSide: BorderSide(width: 2, color: CustomColors.fontColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        borderSide: BorderSide(width: 2, color: CustomColors.fontColor),
      ),
      labelStyle: TextStyle(fontSize: 16, color: CustomColors.fontColor),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(width: 2, color: CustomColors.custom_pink)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(width: 2, color: CustomColors.custom_pink)),
    ),
  );
}

Widget customTextfieldWithMaxLenght(
  String label,
  TextEditingController controller,
  int maxLine,
  int minLine,
  int maxlenght,
) {
  return TextFormField(
    validator: (value) {
      if (value.isNotEmpty) {
        return null;
      } else {
        return "Your message can't be empty";
      }
    },
    controller: controller,
    style: TextStyle(color: CustomColors.fontColor),
    cursorColor: CustomColors.fontColor,
    minLines: minLine,
    maxLines: maxLine,
    maxLength: maxlenght,
    decoration: InputDecoration(
      counterStyle: TextStyle(color: CustomColors.fontColor),
      border: OutlineInputBorder(),
      labelText: '$label',
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        borderSide: BorderSide(width: 2, color: CustomColors.fontColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        borderSide: BorderSide(width: 2, color: CustomColors.fontColor),
      ),
      labelStyle: TextStyle(fontSize: 16, color: CustomColors.fontColor),
    ),
  );
}

Widget customTextfield(
    String label, TextEditingController controller, int maxLine, int minLine) {
  return TextFormField(
    validator: (value) {
      if (value.isNotEmpty) {
        return null;
      } else {
        return "Your message can't be empty";
      }
    },
    controller: controller,
    style: TextStyle(color: CustomColors.fontColor),
    cursorColor: CustomColors.fontColor,
    minLines: minLine,
    maxLines: maxLine,
    decoration: InputDecoration(
      counterStyle: TextStyle(color: CustomColors.fontColor),
      border: OutlineInputBorder(),
      labelText: '$label',
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(17)),
        borderSide: BorderSide(width: 1, color: CustomColors.fontColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(17)),
        borderSide: BorderSide(width: 1, color: CustomColors.fontColor),
      ),
      labelStyle: TextStyle(fontSize: 16, color: CustomColors.fontColor),
    ),
  );
}

Widget customTextfieldNoBorder(String label, TextEditingController controller) {
  return TextFormField(
    validator: (value) {
      if (value.isNotEmpty) {
        return null;
      } else {
        return "error";
      }
    },
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: CustomColors.fontColor, width: 2),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 2, color: CustomColors.fontColor),
      ),
    ),
  );
}
