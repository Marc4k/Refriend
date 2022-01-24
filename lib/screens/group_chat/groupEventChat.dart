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
import 'package:refriend/screens/group_chat/group_bigView.dart';
import 'package:refriend/services/group_service.dart';
import 'package:refriend/widgets/avatar.dart';
import 'package:refriend/widgets/refriendCustomWidgets.dart';

class GroupEventChat extends StatefulWidget {
  final String groupChatName;
  final String groupcode;
  final String groupPictureUrl;
  const GroupEventChat(
      {this.groupChatName, this.groupcode, this.groupPictureUrl});

  @override
  _GroupEventChatState createState() => _GroupEventChatState();
}

class _GroupEventChatState extends State<GroupEventChat> {
//Services
  GroupService _groupService = GroupService();

  final _what = TextEditingController();
  final _where = TextEditingController();
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
                    MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider<GroupMembersCubit>(
                                    create: (BuildContext context) =>
                                        GroupMembersCubit(widget.groupcode)
                                          ..getMembersData())
                              ],
                              child: GroupEventBigView(),
                            ));
                  },
                  child: listViewItemForMainScreen(
                      context, widget.groupChatName, widget.groupPictureUrl),
                ),
                Spacer(),
              ],
            ),
            BlocBuilder<GroupEventCubit, List<GroupEvent>>(
              builder: (context, events) {
                if (events.isEmpty) {
                  return ElevatedButton(
                      onPressed: () async {
                        await showModalBottomSheet(
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20)),
                            ),
                            backgroundColor: CustomColors.backgroundColor2,
                            context: context,
                            builder: (context) {
                              return Container(
                                height: getHeight(context) / 2,
                                child: Column(
                                  children: [
                                    Text("Create a new event"),
                                    Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "What?",
                                            style: GoogleFonts.roboto(
                                                color: CustomColors.fontColor,
                                                fontSize: 20),
                                          ),
                                          emailField("What?", _what),
                                          SizedBox(
                                              height: getHeight(context) / 15),
                                          Text(
                                            "Where?",
                                            style: GoogleFonts.roboto(
                                                color: CustomColors.fontColor,
                                                fontSize: 20),
                                          ),
                                          emailField("Where?", _where),
                                          ElevatedButton(
                                              onPressed: () async {
                                                final DateTime picked =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate:
                                                      selectedDate, // Refer step 1
                                                  firstDate: DateTime(2000),
                                                  lastDate: DateTime(2025),
                                                );
                                              },
                                              child: Text("Pick Date")),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            fixedSize: Size(80, 80),
                                            primary: CustomColors.custom_pink,
                                            elevation: 5,
                                            shape: CircleBorder()),
                                        onPressed: () async {
                                          await _groupService.uploadGroupEvent(
                                              _what.text,
                                              "12:35",
                                              _where.text,
                                              selectedDate,
                                              "moreInformation",
                                              widget.groupcode);

                                          _what.clear();
                                          _where.clear();

                                          Navigator.pop(context);
                                        },
                                        child: Icon(
                                          Icons.check,
                                          size: 50,
                                        )),
                                  ],
                                ),
                              );
                            });
                      },
                      child: Text("Add a new Event"));
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
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(width: getwidth(context) / 100),
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text("event.refriend")),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 8, 2, 8),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Refriend present:",
                                              style: GoogleFonts.roboto(
                                                  fontSize: 12)),
                                          Text(events[index].name,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 18)),
                                          SizedBox(
                                              height: getHeight(context) / 50),
                                          Text("location",
                                              style: GoogleFonts.roboto(
                                                  fontSize: 12)),
                                          Text(events[index].location,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 18)),
                                          SizedBox(
                                              height: getHeight(context) / 50),
                                          Text(events[index].time,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 18)),
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    _groupService
                                                        .setEventasThumpsDown(
                                                            events[index]
                                                                .chatId,
                                                            widget.groupcode);

                                                    context
                                                        .read<GroupEventCubit>()
                                                        .getEvents();

                                                    context
                                                        .read<
                                                            GroupMembersCubit>()
                                                        .getMembersData();
                                                  },
                                                  icon: Icon(
                                                    Icons.thumb_down,
                                                    color: Colors.red,
                                                  )),
                                              IconButton(
                                                  onPressed: () async {
                                                    await _groupService
                                                        .setEventasThumpsUp(
                                                            events[index]
                                                                .chatId,
                                                            widget.groupcode);

                                                    context
                                                        .read<GroupEventCubit>()
                                                        .getEvents();

                                                    context
                                                        .read<
                                                            GroupMembersCubit>()
                                                        .getMembersData();
                                                  },
                                                  icon: Icon(
                                                    Icons.thumb_up,
                                                    color: Colors.green,
                                                  )),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                MultiBlocProvider(
                                                                  providers: [
                                                                    BlocProvider<
                                                                        ChatMessageCubit>(
                                                                      create: (BuildContext context) => ChatMessageCubit(
                                                                          widget
                                                                              .groupcode,
                                                                          events[index]
                                                                              .chatId)
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
                                                  child: Text("Open Chat"))
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            back: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Text("With"),
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
                                            padding: const EdgeInsets.all(8.0),
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
            size: 50,
          ),
          backgroundColor: CustomColors.custom_pink,
          onPressed: () async {
            await showModalBottomSheet(
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
                backgroundColor: CustomColors.backgroundColor2,
                context: context,
                builder: (context) {
                  return Container(
                    height: getHeight(context) / 2,
                    child: Column(
                      children: [
                        Text("Create a new event"),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "What?",
                                style: GoogleFonts.roboto(
                                    color: CustomColors.fontColor,
                                    fontSize: 20),
                              ),
                              emailField("What?", _what),
                              SizedBox(height: getHeight(context) / 15),
                              Text(
                                "Where?",
                                style: GoogleFonts.roboto(
                                    color: CustomColors.fontColor,
                                    fontSize: 20),
                              ),
                              emailField("Where?", _where),
                              ElevatedButton(
                                  onPressed: () async {
                                    final DateTime picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate, // Refer step 1
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2025),
                                    );
                                  },
                                  child: Text("Pick Date")),
                            ],
                          ),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(80, 80),
                                primary: CustomColors.custom_pink,
                                elevation: 5,
                                shape: CircleBorder()),
                            onPressed: () async {
                              await _groupService.uploadGroupEvent(
                                  _what.text,
                                  "12:35",
                                  _where.text,
                                  selectedDate,
                                  "moreInformation",
                                  widget.groupcode);

                              _what.clear();
                              _where.clear();

                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.check,
                              size: 50,
                            )),
                      ],
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
