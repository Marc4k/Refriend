import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refriend/constant/colors.dart';
import 'package:refriend/constant/size.dart';
import 'package:refriend/cubit/chatMessage_cubit.dart';
import 'package:refriend/models/messages.dart';
import 'package:refriend/services/chat_service.dart';
import 'package:refriend/widgets/refriendCustomWidgets.dart';

class ChatScreen extends StatefulWidget {
  final String eventName;
  final String groupcode;
  final String chatID;
  ChatScreen({this.eventName, this.groupcode, this.chatID});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = ScrollController();
  final _message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.backgroundColor2,
        body: Column(
          children: [
            customWaveWithCustomText(context, widget.eventName),
            Expanded(child: BlocBuilder<ChatMessageCubit, List<Message>>(
                builder: (context, message) {
              if (message.isEmpty) {
                return Container();
              } else {
                return ListView.builder(
                  controller: _controller,
                  itemCount: message.length,
                  itemBuilder: (context, index) {
                    print(widget.chatID);
                    if (message[index].isNotAMessage == true) {
                      return Center(
                        child: Text(
                          ChatService()
                              .formateDateToDateOnly(message[index].createdAt),
                          style: TextStyle(fontSize: 15, color: Colors.white38),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.all(getwidth(context) / 90),
                        child: chatBubbleCustom(
                            message[index].name,
                            message[index].text,
                            message[index].isSender,
                            message[index].createdAt,
                            context),
                      );
                    }
                  },
                );
              }
            })),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: TextFormField(
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    controller: _message,
                    minLines: 1,
                    cursorColor: Colors.white,
                    maxLines: 5,
                    maxLength: 255,
                    decoration: InputDecoration(
                      counterStyle: TextStyle(color: CustomColors.fontColor),
                      counterText: "",
                      fillColor: Colors.transparent,

                      contentPadding: EdgeInsets.fromLTRB(
                          getwidth(context) / 25, 0, getwidth(context) / 25, 0),
                      hintText: "Message",

                      hintStyle: TextStyle(fontSize: 16, color: Colors.white),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(width: 1, color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(width: 1, color: Colors.white),
                      ),
                      // enabledBorder: InputBorder.none,
                      //focusedBorder: InputBorder.none,
                    ),
                  )),
                  SizedBox(width: getwidth(context) / 40),
                  CircleAvatar(
                    backgroundColor: CustomColors.custom_pink,
                    child: IconButton(
                        onPressed: () async {
                          if (_message.text.isNotEmpty) {
                            await ChatService().sendMessageToDatabase(
                                _message.text, widget.groupcode, widget.chatID);
                            _message.clear();

                            context.read<ChatMessageCubit>().getMessages();

                            if (_controller.hasClients) {
                              _controller
                                  .jumpTo(_controller.position.maxScrollExtent);
                            }
                          }
                        },
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
            new StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chats/${widget.chatID}/message")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    context.read<ChatMessageCubit>().getMessages();
                    if (_controller.hasClients) {
                      _controller.jumpTo(_controller.position.maxScrollExtent);
                    }
                    return Container();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
