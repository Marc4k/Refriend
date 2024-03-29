import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:refriend/database/database_chat.dart';
import 'package:refriend/database/database_user.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:intl/intl.dart';

class ChatService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future sendMessageToDatabase(
      String message, String groupCode, String chatID) async {
    bool repeateChatId = true;
    String messageIdString;

    while (repeateChatId == true) {
      var uuid = Uuid();
      var messageID;
      messageID = uuid.v4(options: {'rng': UuidUtil.cryptoRNG});
      dynamic isSameChatId =
          await DatabaseChat().checkChatId(messageID, groupCode);

      if (isSameChatId == true) {
        continue;
      } else if (isSameChatId == false) {
        repeateChatId = false;
        messageIdString = messageID;
      }
    }
    String userID = _auth.currentUser.uid;

    await DatabaseChat()
        .sendMessage(message, groupCode, chatID, userID, messageIdString);
    return;
  }

  String formateDateToTimeOnly(Timestamp time) {
    DateTime date =
        DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch);

    String formattedDate = DateFormat('kk:mm').format(date);
    return formattedDate;
  }

  String formateDateToDateOnly(Timestamp time) {
    DateTime date =
        DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch);

    String formattedDate = DateFormat('dd-MM-yyyy').format(date);
    return formattedDate;
  }
}
