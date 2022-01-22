import 'package:firebase_auth/firebase_auth.dart';
import 'package:refriend/database/database_chat.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class ChatService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future sendMessageToDatabase(
      String message, String groupCode, String eventID) async {
    bool repeateChatId = true;
    String chatIdString;

    while (repeateChatId == true) {
      var uuid = Uuid();
      var chatId;
      chatId = uuid.v4(options: {'rng': UuidUtil.cryptoRNG});

      dynamic isSameChatId =
          await DatabaseChat().checkChatId(chatId, groupCode);

      if (isSameChatId == true) {
        continue;
      } else if (isSameChatId == false) {
        repeateChatId = false;
        chatIdString = chatId;
      }
    }
    String userID = _auth.currentUser.uid;
    await DatabaseChat().sendMessage(message, groupCode, eventID, userID);
    return;
  }
}
