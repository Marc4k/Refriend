import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:refriend/database/database_group.dart';
import 'package:refriend/database/database_user.dart';
import 'package:refriend/models/group.dart';
import 'package:refriend/models/groupMembers.dart';
import 'package:refriend/services/user_service.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class GroupService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create the group and return the invite code
  Future createGroupAndInvite(
      String groupName, String groupDesc, File image) async {
    final User user = _auth.currentUser;
    final uid = user.uid;
    List members = [];
    members.add(uid);

    bool repeateInviteCode = true;
    bool repeateGroupeCode = true;
    var groupCode;
    String inviteCode;

    while (repeateInviteCode == true) {
      while (repeateGroupeCode == true) {
        //create invite code
        inviteCode = getInviteCode();

        //create group code
        var uuid = Uuid();
        groupCode = uuid.v4(options: {'rng': UuidUtil.cryptoRNG});

        //check the invite code
        dynamic isSameInviteCode =
            await DatabaseServiceGroup().checkInvite(inviteCode);

        //check the group code
        dynamic isSameGroupeCode =
            await DatabaseServiceGroup().checkGroup(groupCode);

        if (isSameInviteCode == true) {
          continue;
        } else if (isSameInviteCode == false) {
          repeateInviteCode = false;
        }

        if (isSameGroupeCode == true) {
          continue;
        } else if (isSameGroupeCode == false) {
          repeateGroupeCode = false;
        }
      }
    }

    //upload the group picture to the firestore
    dynamic groupImg =
        await DatabaseServiceGroup().uploadGroupImage(image, groupCode);

    dynamic groupImage = await getGroupPictureFromPath(groupImg);

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    messaging.subscribeToTopic(groupCode);

    //create group
    await DatabaseServiceGroup().createGroup(
      inviteCode,
      groupName,
      groupDesc,
      groupCode,
      groupImage,
      members,
    );

    //return the invite code for the group
    return inviteCode;
  }

  Future joinGroup(String inviteCode) async {
    final User user = _auth.currentUser;
    final uid = user.uid;
    bool uploaded = false;
    //check Invite Code
    dynamic groupCode = await DatabaseServiceGroup().getGroupCode(inviteCode);

    //join Group
    print(groupCode);
    if (groupCode == null) {
      print("The Code is not valid!");
      return null;
    } else {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      messaging.subscribeToTopic(groupCode);

      print("Joined the group");
      await DatabaseServiceGroup().joinGroup(groupCode, uid);
      uploaded = true;
      return uploaded;
    }
  }

  Future getyourGroupsData() async {
    //get the current User
    final User user = _auth.currentUser;
    final uid = user.uid;

    //get all Groups where the user joined
    dynamic groupDataList = await DatabaseServiceGroup().getYourGroupCodes(uid);

    return groupDataList;
    //return data;
  }

  //get profil Picture from Storage
  Future<String> getGroupPicture(String groupCode) async {
    final ref = FirebaseStorage.instance.ref("GroupImage/$groupCode/");
    final result = await ref.listAll();

    final urls = await _getDownloadLinks(result.items);
    String stringUrl = urls[0];
    return stringUrl;
  }

  //get profil Picture vrom Path
  Future<String> getGroupPictureFromPath(String groupPath) async {
    var newPath = groupPath.split("/");
    var newPathTogether = newPath[0] + "/" + newPath[1] + "/";

    final ref = FirebaseStorage.instance.ref(newPathTogether);
    final result = await ref.listAll();

    final urls = await _getDownloadLinks(result.items);

    return urls[0];
  }

  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  //upload a group event
  Future uploadGroupEvent(String eventname, String time, String location,
      DateTime date, String moreInformation, String groupCode) async {
    //get the userId
    final User user = _auth.currentUser;
    final uid = user.uid;

    bool repeateChatId = true;
    String chatIdString;
    while (repeateChatId == true) {
      //create the chatId
      var uuid = Uuid();
      var chatId;
      chatId = uuid.v4(options: {'rng': UuidUtil.cryptoRNG});

      //check the groupId
      dynamic isSameChatId =
          await DatabaseServiceGroup().checkEventChatId(chatId, groupCode);

      if (isSameChatId == true) {
        continue;
      } else if (isSameChatId == false) {
        repeateChatId = false;
        chatIdString = chatId;
      }
    }
    DatabaseServiceGroup().createEvent(eventname, time, location,
        moreInformation, groupCode, chatIdString, date, uid);
  }

  Future getGroupEvent(String groupCode) async {
    dynamic groupEventList =
        await DatabaseServiceGroup().getGroupChatMessages(groupCode);

    return groupEventList;
  }

  Future getGroupsMembersData(String groupCode) async {
    List<GroupMembers> groupMembersList = [];

    dynamic userList =
        await DatabaseServiceGroup().getGroupMembersId(groupCode);

    for (int i = 0; i < userList.length; i++) {
      dynamic user = await DatabaseServiceUser().getUserInfos(userList[i]);

      dynamic profilUrl =
          await DatabaseServiceUser().getUserProfilUrl(userList[i]);

      groupMembersList.add(GroupMembers(
          name: user["name"], userId: user["userid"], imageUrl: profilUrl));
    }
    if (groupMembersList.isNotEmpty) {
      return groupMembersList;
    }
  }

  Future setEventasThumpsUp(String chatId, String groupCode) async {
    final User user = _auth.currentUser;
    final uid = user.uid;

    await DatabaseServiceGroup().setEventAsThumbsUp(uid, groupCode, chatId);
  }

  Future setEventasThumpsDown(String chatId, String groupCode) async {
    final User user = _auth.currentUser;
    final uid = user.uid;

    await DatabaseServiceGroup().setEventAsThumbsDown(uid, groupCode, chatId);
  }

  Future leaveGroup(String groupId) async {
    final User user = _auth.currentUser;
    final uid = user.uid;

    await DatabaseServiceGroup().leaveGroup(uid, groupId);
  }
}

//generate the invite code
String getInviteCode() {
  var rng = new Random();
  int code;
  code = 10000 + rng.nextInt(99999 - 10000);

  String stringcode = code.toString();
  return stringcode;
}
