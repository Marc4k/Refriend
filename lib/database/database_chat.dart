import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:refriend/database/database_group.dart';
import 'package:refriend/models/groupEvents.dart';
import 'package:refriend/models/messages.dart';
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
      return messagesChat;
    } catch (error) {
      return messagesChat;
    }
  }

  Future sendMessage(String message, String groupCode, String chatId,
      String senderUserID) async {
    final CollectionReference groupsChat =
        FirebaseFirestore.instance.collection('chats/$chatId/message');

    bool repeateChatId = true;
    String chatIdString;

    while (repeateChatId == true) {
      var uuid = Uuid();
      var chatId;
      chatId = uuid.v4(options: {'rng': UuidUtil.cryptoRNG});

      dynamic isSameChatId =
          await DatabaseServiceGroup().checkChatId(chatId, groupCode);

      if (isSameChatId == true) {
        continue;
      } else if (isSameChatId == false) {
        repeateChatId = false;
        chatIdString = chatId;
      }
    }

    DateTime now = new DateTime.now();
    DateTime dateOfCreation = new DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);

    return await groupsChat.doc("$chatIdString").set({
      "Message": message,
      "SenderID": senderUserID,
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
