import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refriend/constant/colors.dart';
import 'package:refriend/constant/size.dart';
import 'package:refriend/cubit/chatMessage_cubit.dart';
import 'package:refriend/cubit/groupEvent_cubit.dart';
import 'package:refriend/cubit/groupMembers_cubit.dart';
import 'package:refriend/models/groupEvents.dart';
import 'package:refriend/models/groupMembers.dart';
import 'package:refriend/screens/chat/ChatUINew.dart';
import 'package:refriend/screens/createEvent.dart';
import 'package:refriend/screens/group_chat/group_bigView.dart';
import 'package:refriend/services/group_service.dart';
import 'package:refriend/widgets/avatar.dart';
import 'package:refriend/widgets/refriendCustomWidgets.dart';

class GroupEventChat extends StatefulWidget {
  final String groupChatName;
  final String groupcode;
  final String groupPictureUrl;
  final String inviteCode;
  const GroupEventChat(
      {this.groupChatName,
      this.groupcode,
      this.groupPictureUrl,
      this.inviteCode});

  @override
  _GroupEventChatState createState() => _GroupEventChatState();
}

class _GroupEventChatState extends State<GroupEventChat> {
//Services
  GroupService _groupService = GroupService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final _what = TextEditingController();
  final _where = TextEditingController();

  bool thumsUpDownShow = true;

  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.backgroundColor2,
        body: Column(
          children: [
            customWave(context),
            Row(
              children: [
                Expanded(
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: getwidth(context) / 15,
                        ))),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider<GroupMembersCubit>(
                                    create: (BuildContext context) =>
                                        GroupMembersCubit(widget.groupcode)
                                          ..getMembersData(),
                                  ),
                                ],
                                child: GroupEventBigView(
                                  inviteCode: widget.inviteCode,
                                  groupName: widget.groupChatName,
                                ))));
                  },
                  child: listViewItemForMainScreen(context,
                      widget.groupChatName, widget.groupPictureUrl, 0, false),
                ),
                Spacer(),
              ],
            ),
            BlocBuilder<GroupEventCubit, List<GroupEvent>>(
              builder: (context, events) {
                if (events.isEmpty) {
                  return Text("no events Create one");
                } else {
                  return NotificationListener<OverscrollIndicatorNotification>(
                    onNotification:
                        (OverscrollIndicatorNotification overScroll) {
                      overScroll.disallowIndicator();
                      return false;
                    },
                    child: Expanded(
                        child: ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: FlipCard(
                            fill: Fill
                                .fillBack, // Fill the back side of the card to make in the same size as the front.
                            direction: FlipDirection.HORIZONTAL, // default
                            front: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22)),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(getwidth(context) / 50),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: getwidth(context) / 50),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text("event.refriend")),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(
                                              getwidth(context) / 50),
                                          child: SizedBox(
                                            width: getwidth(context) / 10,
                                            height: getHeight(context) / 5,
                                            child: RotatedBox(
                                              quarterTurns: 1,
                                              child: BarcodeWidget(
                                                  drawText: false,
                                                  data: events[index].name,
                                                  barcode: Barcode.code128()),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text("What?",
                                                style: GoogleFonts.roboto(
                                                    fontSize: 15)),
                                            Text(events[index].name,
                                                style: GoogleFonts.roboto(
                                                    fontSize: 22)),
                                            SizedBox(
                                                height:
                                                    getHeight(context) / 100),
                                            Text("Where?",
                                                style: GoogleFonts.roboto(
                                                    fontSize: 15)),
                                            Text(events[index].location,
                                                style: GoogleFonts.roboto(
                                                    fontSize: 22)),
                                            SizedBox(
                                                height:
                                                    getHeight(context) / 100),
                                            Text("When?",
                                                style: GoogleFonts.roboto(
                                                    fontSize: 15)),
                                            Text(events[index].time,
                                                style: GoogleFonts.roboto(
                                                    fontSize: 22)),
                                          ],
                                        ),
                                        Spacer(),
                                        Column(
                                          children: [
                                            CircleAvatar(
                                                backgroundColor:
                                                    CustomColors.custom_pink,
                                                child: IconButton(
                                                    color: Colors.white,
                                                    onPressed: () async {
                                                      await _groupService
                                                          .setEventasThumpsUp(
                                                              events[index]
                                                                  .chatId,
                                                              widget.groupcode);

                                                      context
                                                          .read<
                                                              GroupEventCubit>()
                                                          .getEvents();

                                                      context
                                                          .read<
                                                              GroupMembersCubit>()
                                                          .getMembersData();
                                                    },
                                                    icon: Icon(
                                                      Icons.thumb_up,
                                                    ))),
                                            SizedBox(
                                                height:
                                                    getHeight(context) / 100),
                                            CircleAvatar(
                                                backgroundColor:
                                                    CustomColors.custom_pink,
                                                child: IconButton(
                                                    color: Colors.white,
                                                    onPressed: () async {
                                                      await _groupService
                                                          .setEventasThumpsDown(
                                                              events[index]
                                                                  .chatId,
                                                              widget.groupcode);

                                                      context
                                                          .read<
                                                              GroupEventCubit>()
                                                          .getEvents();

                                                      context
                                                          .read<
                                                              GroupMembersCubit>()
                                                          .getMembersData();
                                                    },
                                                    icon: Icon(
                                                      Icons.thumb_down,
                                                    ))),
                                            SizedBox(
                                                height:
                                                    getHeight(context) / 100),
                                            CircleAvatar(
                                                backgroundColor:
                                                    CustomColors.custom_pink,
                                                child: IconButton(
                                                    color: Colors.white,
                                                    onPressed: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  MultiBlocProvider(
                                                                    providers: [
                                                                      BlocProvider<
                                                                          ChatMessageCubit>(
                                                                        create: (BuildContext context) => ChatMessageCubit(
                                                                            widget.groupcode,
                                                                            events[index].chatId)
                                                                          ..getMessages(),
                                                                      ),
                                                                    ],
                                                                    child:
                                                                        ChatScreen(
                                                                      eventName:
                                                                          events[index]
                                                                              .name,
                                                                      groupcode:
                                                                          widget
                                                                              .groupcode,
                                                                      chatID: events[
                                                                              index]
                                                                          .chatId,
                                                                    ),
                                                                  )));
                                                    },
                                                    icon: Icon(
                                                      Icons.chat,
                                                    ))),
                                          ],
                                        ),
                                        SizedBox(width: getwidth(context) / 50),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            back: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22)),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  BlocBuilder<GroupMembersCubit,
                                      List<GroupMembers>>(
                                    builder: (context, members) {
                                      if (members.isEmpty) {
                                        return SpinKitChasingDots(
                                          color: Colors.white,
                                          size: 35,
                                        );
                                      } else {
                                        return Flexible(
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                getHeight(context) / 50),
                                            child: GridView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: members.length,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisSpacing: 15,
                                                      mainAxisSpacing: 0,
                                                      crossAxisCount: 5),
                                              itemBuilder:
                                                  (context, index_grid) {
                                                return avatar(
                                                    members[index_grid]
                                                        .imageUrl,
                                                    events[index].thumpsUp,
                                                    events[index].thumpsDown,
                                                    members[index_grid].userId);
                                              },
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )),
                  );
                }
              },
            ),
            new StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("groups_events/${widget.groupcode}/event_chat")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    context.read<GroupEventCubit>().getEvents();
                    return Container();
                  }
                }),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            size: 35,
          ),
          backgroundColor: CustomColors.custom_pink,
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return CreateEvent(
                  groupCode: widget.groupcode,
                );
              },
            ));
          },
        ),
      ),
    );
  }
}
