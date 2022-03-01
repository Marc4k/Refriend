import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String text;
  final String name;
  final bool isSender;
  final Timestamp createdAt;
  final bool isNotAMessage;
  Message(
      {this.text,
      this.name,
      this.isSender,
      this.createdAt,
      this.isNotAMessage});
}
