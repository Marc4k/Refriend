import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:refriend/database/database_group.dart';
import 'package:refriend/models/messages.dart';
import 'package:refriend/services/user_service.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class DatabaseChat {
  final CollectionReference groups =
      FirebaseFirestore.instance.collection('groups');

  Future getMessagesChat(String groupCode, String chatID) async {
    List<Message> messagesChat = [];

    try {
      final CollectionReference groupsChat =
          FirebaseFirestore.instance.collection('chats/$chatID/message');

      final FirebaseAuth _auth = FirebaseAuth.instance;
      String userID = _auth.currentUser.uid;
      bool isSender;
      try {
        await groupsChat.get().then((snapshot) {
          snapshot.docs.forEach((element) {
            Map<String, dynamic> data = element.data();

            if (userID == data["SenderID"]) {
              isSender = true;
            } else {
              isSender = false;
            }
            messagesChat.add(
              Message(
                  name: data["Name"],
                  text: data["Message"],
                  isSender: isSender,
                  createdAt: data["CreatedAt"]),
            );
          });
        });
      } catch (e) {
        print(e.toString());
        return null;
      }
      messagesChat.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      messagesChat.insert(0,
          Message(createdAt: messagesChat[0].createdAt, isNotAMessage: true));

      // int messageChatLength = messagesChat.length;
      for (int i = 0; i <= messagesChat.length; i++) {
        if (messagesChat[i].isNotAMessage != true) {
          DateTime dateFirst = DateTime.fromMicrosecondsSinceEpoch(
              messagesChat[i].createdAt.microsecondsSinceEpoch);

          DateTime dateSecond = DateTime.fromMicrosecondsSinceEpoch(
              messagesChat[i + 1].createdAt.microsecondsSinceEpoch);

          DateTime onlyDateFirst =
              DateTime(dateFirst.year, dateFirst.month, dateFirst.day);
          DateTime onlyDateSecond =
              DateTime(dateSecond.year, dateSecond.month, dateSecond.day);

          int test = dateFirst.difference(dateSecond).inDays;
          if (onlyDateFirst.difference(onlyDateSecond).inDays != 0) {
            if (messagesChat[i + 1].isNotAMessage != true) {
              messagesChat.insert(
                  i + 1,
                  Message(
                      createdAt: messagesChat[i + 1].createdAt,
                      isNotAMessage: true));
            }
          }
        }
      }
      return messagesChat;
    } catch (error) {
      return messagesChat;
    }
  }

  Future sendMessage(String message, String groupCode, String chatId,
      String senderUserID, String messageID) async {
    final CollectionReference groupsChat =
        FirebaseFirestore.instance.collection('chats/$chatId/message');

    DateTime now = new DateTime.now();
    DateTime dateOfCreation = new DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);

    dynamic username = await UserService().logedInUserInfo();

    return await groupsChat.doc("$messageID").set({
      "Message": message,
      "SenderID": senderUserID,
      "Name": username,
      "CreatedAt": dateOfCreation,
      "ChatID": chatId,
      "GroupID": groupCode
    });
  }

  Future checkChatId(String chatId, String groupCode) async {
    final CollectionReference groupsChat =
        FirebaseFirestore.instance.collection('groups_events/$groupCode/chats');

    bool isSame = false;
    try {
      await groupsChat.get().then((snapshot) {
        snapshot.docs.forEach((element) {
          Map<String, dynamic> data = element.data();
          if (data["ChatID"] == chatId) {
            isSame = true;
          }
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
    return isSame;
  }
}
