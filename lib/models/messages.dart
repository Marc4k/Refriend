import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String text;
  final bool isSender;
  final Timestamp createdAt;
  Message({this.text, this.isSender, this.createdAt});
}
