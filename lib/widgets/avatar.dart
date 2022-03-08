import 'package:flutter/material.dart';

Widget avatar(String imageUrl, List thumpsUp, List thumpsDown, String userId) {
  if (thumpsDown.isEmpty && thumpsUp.isEmpty) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      maxRadius: 10,
      minRadius: 10,
      backgroundImage: NetworkImage(imageUrl),
      child: Icon(
        Icons.hourglass_empty,
        color: Colors.white,
      ),
    );
  }
  if (thumpsUp != null) {
    for (int i = 0; i < thumpsUp.length; i++) {
      if (thumpsUp[i] == userId) {
        return CircleAvatar(
          backgroundColor: Colors.white,
          maxRadius: 10,
          minRadius: 10,
          backgroundImage: NetworkImage(imageUrl),
          child: Icon(
            Icons.thumb_up_sharp,
            color: Colors.green,
          ),
        );
      }
    }
  }

  if (thumpsDown != null) {
    for (int i = 0; i < thumpsDown.length; i++) {
      if (thumpsDown[i] == userId) {
        return CircleAvatar(
          backgroundColor: Colors.white,
          maxRadius: 10,
          minRadius: 10,
          backgroundImage: NetworkImage(imageUrl),
          child: Icon(
            Icons.thumb_down_sharp,
            color: Colors.red,
          ),
        );
      }
    }
  }

  return CircleAvatar(
    maxRadius: 10,
    minRadius: 10,
    backgroundColor: Colors.white,
    backgroundImage: NetworkImage(imageUrl),
    child: Icon(
      Icons.hourglass_empty,
      color: Colors.white,
    ),
  );
}
