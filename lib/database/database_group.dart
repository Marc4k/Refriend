import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:refriend/models/group.dart';
import 'package:refriend/models/groupEvents.dart';
import 'package:refriend/services/group_service.dart';

//The database  for the group functions
//ToDO: TimeStamp is not working (getYourGroupCodes)
class DatabaseServiceGroup {
  final String uid;

  DatabaseServiceGroup({this.uid});

  //instance of the groups document
  final CollectionReference groups =
      FirebaseFirestore.instance.collection('groups');

  //upload group picture to the cloud firestore
  Future uploadGroupImage(File image, String groupCode) async {
    final destination = "GroupImage/$groupCode/groupImg.png";
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      await ref.putFile(image);
      return destination;
    } on FirebaseException catch (e) {
      return null;
    }
  }

  //check if the invite code is already used
  Future checkInvite(String inviteCode) async {
    bool isSame = false;
    try {
      await groups.get().then((snapshot) {
        snapshot.docs.forEach((element) {
          Map<String, dynamic> data = element.data();
          if (data["InviteCode"] == inviteCode) {
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

  //check if the group code is already used
  Future checkGroup(String groupCode) async {
    bool isSame = false;
    try {
      await groups.get().then((snapshot) {
        snapshot.docs.forEach((element) {
          Map<String, dynamic> data = element.data();
          if (data["GroupCode"] == groupCode) {
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

  //creates a new document with the group informations
  Future createGroup(String invitecode, String groupName, String description,
      String groupcode, String groupImg, List groupMembers) async {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);

    return await groups.doc(groupcode).set({
      "GroupName": groupName,
      "Description": description,
      "GroupCode": groupcode,
      "GroupImg": groupImg,
      "InviteCode": invitecode,
      "Members": groupMembers,
      "CreateDate": date,
    });
  }

  //join the group with a invite code
  Future joinGroup(String groupCode, String userID) async {
    String realCode = "";
    List member = [];
    String desc = "";
    String groupImg = "";
    String groupName = "";
    String inviteCode = "";

    try {
      await groups.get().then((snapshot) {
        snapshot.docs.forEach((element) {
          Map<String, dynamic> data = element.data();
          if (data["GroupCode"] == groupCode) {
            realCode = data["GroupCode"];
          }
        });
      });

      await groups.get().then((snapshot) {
        snapshot.docs.forEach((element) {
          Map<String, dynamic> data = element.data();
          if (data["GroupCode"] == realCode) {
            member = data["Members"];
            desc = data["Description"];
            groupImg = data["GroupImg"];
            groupName = data["GroupName"];
            inviteCode = data["InviteCode"];
          }
        });
      });

      member.add(userID);

      return await groups.doc(groupCode).set({
        "GroupName": groupName,
        "Description": desc,
        "GroupCode": realCode,
        "GroupImg": groupImg,
        "InviteCode": inviteCode,
        "Members": member,
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //get the Group code with the Invite Code
  Future getGroupCode(String inviteCode) async {
    String groupCode = "";
    try {
      await groups.get().then((snapshot) {
        snapshot.docs.forEach((element) {
          Map<String, dynamic> data = element.data();
          if (data["InviteCode"] == inviteCode) {
            groupCode = data["GroupCode"];
          }
        });
      });
      if (groupCode == "") {
        return null;
      } else {
        return groupCode;
      }
    } catch (e) {
      print(e.toString());
      //return null;
    }
  }

  //get the group data of the group you are in
  Future getYourGroupCodes(String userID) async {
    List yourGroups = [];
    int length;

    try {
      await groups.get().then((snapshot) {
        snapshot.docs.forEach((element) {
          Map<String, dynamic> data = element.data();

          length = data["Members"].length;
          for (int i = 0; i < length; i++) {
            if (data["Members"][i] == userID) {
              yourGroups.add(data["GroupCode"]);
            }
          }
        });
      });
    } catch (e) {
      print(e.toString());
      //return null;
    }

    List<Group> groupModels = [];

    try {
      await groups.get().then((snapshot) {
        snapshot.docs.forEach((element) {
          Map<String, dynamic> data = element.data();
          for (int i = 0; i < yourGroups.length; i++) {
            if (data["GroupCode"] == yourGroups[i]) {
              groupModels.add(Group(
                description: data["Description"],
                groupCode: data["GroupCode"],
                inviteCode: data["InviteCode"],
                groupImg: data["GroupImg"],
                name: data["GroupName"],
                // newMessages: data["newMessage"]
              ));
            }
          }
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }

    return groupModels;
  }

  //returns a map of lists where all the data of the group is stored (where you are a member)
  Future getGroupData(List groupCode) async {
    String desc = "";
    String groupImg = "";
    String groupName = "";
    String inviteCode = "";
    List<Map<String, String>> groupsList = [{}];

    //get all data
    try {
      await groups.get().then((snapshot) {
        snapshot.docs.forEach((element) {
          Map<String, dynamic> data = element.data();

          if (data["GroupCode"] == groupCode[0]) {
            groups.add({
              "GroupName": groupName,
              "Description": desc,
              "GroupCode": groupCode,
              "GroupImg": groupImg,
              "InviteCode": inviteCode,
            });
          }
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }

    return groupsList;
  }

  Future createEvent(
      String eventName,
      String time,
      String location,
      String moreInformation,
      String groupCode,
      String chatId,
      DateTime date,
      String userId) async {
    List thumpsUp = [];
    List thumpsDown = [];

    final CollectionReference groups_events = FirebaseFirestore.instance
        .collection('groups_events/$groupCode/event_chat');

    DateTime now = new DateTime.now();
    DateTime dateOfCreation = new DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);

    return await groups_events.doc("$chatId").set({
      "EventName": eventName,
      "Description": moreInformation,
      "Time": time,
      "Date": date,
      "Location": location,
      "ChatID": chatId,
      "GroupID": groupCode,
      "CreatedAt": dateOfCreation,
      "CreatedFrom": userId,
      "ThumpsUp": thumpsUp,
      "ThumpsDown": thumpsDown,
    });
  }

  Future checkEventChatId(String chatId, String groupCode) async {
    final CollectionReference groups_events = FirebaseFirestore.instance
        .collection('groups_events/$groupCode/event_chat');

    bool isSame = false;
    try {
      await groups_events.get().then((snapshot) {
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

  Future leaveGroup(String userId, String groupCode) async {
    Map groupData;

    final CollectionReference group =
        FirebaseFirestore.instance.collection('groups/');

    //get the group data
    await group.get().then((snapshot) {
      snapshot.docs.forEach((element) {
        Map<String, dynamic> data = element.data();
        if (data["GroupCode"] == groupCode) {
          groupData = data;
        }
      });
    });

    List users = groupData["Members"];

    for (int i = 0; i < users.length; i++) {
      if (users[i] == userId) {
        users.removeAt(i);
      }
    }

    DatabaseServiceGroup().createGroup(
        groupData["InviteCode"],
        groupData["GroupName"],
        groupData["Description"],
        groupData["GroupCode"],
        groupData["GroupImg"],
        users);
  }

  Future checkChatId(String chatId, String groupCode) async {
    final CollectionReference groups_events =
        FirebaseFirestore.instance.collection('groups_events/$groupCode/chats');

    bool isSame = false;
    try {
      await groups_events.get().then((snapshot) {
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

  Future setEventAsThumbsUp(
      String userId, String groupCode, String chatId) async {
    String createdFrom;
    String eventName;
    String time;
    String location;
    String moreInformation;
    Timestamp date;
    Timestamp created;
    List thumpsUp = [];
    List thumpsDown = [];
    bool alreadyThumpsUp = false;
    bool alreadyThumpsDown = false;
    final CollectionReference groupsEvents = FirebaseFirestore.instance
        .collection('groups_events/$groupCode/event_chat');

    try {
      await groupsEvents.get().then((snapshot) {
        snapshot.docs.forEach((element) {
          Map<String, dynamic> data = element.data();
          if (data["ChatID"] == chatId) {
            created = data["CreatedAt"];
            createdFrom = data["CreatedFrom"];
            date = data["Date"];
            moreInformation = data["Description"];
            eventName = data["EventName"];
            location = data["Location"];
            time = data["Time"];
            thumpsUp = data["ThumpsUp"];
            thumpsDown = data["ThumpsDown"];
          }
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }

    if (thumpsUp == null) {
      thumpsUp = [];
    }

    for (int i = 0; i < thumpsUp.length; i++) {
      if (thumpsUp[i] == userId) {
        alreadyThumpsUp = true;
      }
    }
    for (int i = 0; i < thumpsDown.length; i++) {
      if (thumpsDown[i] == userId) {
        alreadyThumpsDown = true;
      }
    }

    if (alreadyThumpsUp == false && alreadyThumpsDown == false) {
      thumpsUp.add(userId);
    }

    final CollectionReference groupsEvents2 = FirebaseFirestore.instance
        .collection('groups_events/$groupCode/event_chat');

    return await groupsEvents2.doc("$chatId").set({
      "EventName": eventName,
      "Description": moreInformation,
      "Time": time,
      "Date": date,
      "Location": location,
      "ChatID": chatId,
      "CreatedAt": created,
      "CreatedFrom": createdFrom,
      "ThumpsUp": thumpsUp,
      "ThumpsDown": thumpsDown,
    });
  }

  Future setEventAsThumbsDown(
      String userId, String groupCode, String chatId) async {
    String createdFrom;
    String eventName;
    String time;
    String location;
    String moreInformation;
    Timestamp date;
    Timestamp created;
    List thumpsUp = [];
    List thumpsDown = [];
    bool alreadyThumpsDown = false;
    bool alreadyThumpsUp = false;
    final CollectionReference groupsEvents = FirebaseFirestore.instance
        .collection('groups_events/$groupCode/event_chat');

    try {
      await groupsEvents.get().then((snapshot) {
        snapshot.docs.forEach((element) {
          Map<String, dynamic> data = element.data();
          if (data["ChatID"] == chatId) {
            created = data["CreatedAt"];
            createdFrom = data["CreatedFrom"];
            date = data["Date"];
            moreInformation = data["Description"];
            eventName = data["EventName"];
            location = data["Location"];
            time = data["Time"];
            thumpsUp = data["ThumpsUp"];
            thumpsDown = data["ThumpsDown"];
          }
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
    if (thumpsDown == null) {
      thumpsDown = [];
    }
    for (int i = 0; i < thumpsDown.length; i++) {
      if (thumpsDown[i] == userId) {
        alreadyThumpsDown = true;
      }
    }

    for (int i = 0; i < thumpsUp.length; i++) {
      if (thumpsUp[i] == userId) {
        alreadyThumpsUp = true;
      }
    }
    if (alreadyThumpsDown == false && alreadyThumpsUp == false) {
      thumpsDown.add(userId);
    }

    final CollectionReference groupsEvents2 = FirebaseFirestore.instance
        .collection('groups_events/$groupCode/event_chat');

    return await groupsEvents2.doc("$chatId").set({
      "EventName": eventName,
      "Description": moreInformation,
      "Time": time,
      "Date": date,
      "Location": location,
      "ChatID": chatId,
      "CreatedAt": created,
      "CreatedFrom": createdFrom,
      "ThumpsUp": thumpsUp,
      "ThumpsDown": thumpsDown,
    });
  }

  Future getGroupChatMessages(String groupCode) async {
    List<GroupEvent> groupEvents = [];

    final CollectionReference groups_events = FirebaseFirestore.instance
        .collection('groups_events/$groupCode/event_chat');

    try {
      await groups_events.get().then((snapshot) {
        snapshot.docs.forEach((element) {
          Map<String, dynamic> data = element.data();
          groupEvents.add(
            GroupEvent(
                description: data["Description"],
                name: data["EventName"],
                time: data["Time"],
                location: data["Location"],
                chatId: data["ChatID"],
                thumpsUp: data["ThumpsUp"],
                thumpsDown: data["ThumpsDown"]),
          );
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
    return groupEvents;
  }

  Future getGroupMembersId(String groupCode) async {
    List member = [];

    try {
      await groups.get().then((snapshot) {
        snapshot.docs.forEach((element) {
          Map<String, dynamic> data = element.data();

          if (data["GroupCode"] == groupCode) {
            for (int i = 0; i < data["Members"].length; i++) {
              member.add(data["Members"][i]);
            }
          }
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }

    if (member.isNotEmpty) {
      return member;
    }
  }
}
