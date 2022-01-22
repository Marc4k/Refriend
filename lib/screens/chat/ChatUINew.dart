import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:refriend/constant/colors.dart';
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
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ChatBubble(
                        elevation: 0,
                        clipper: ChatBubbleClipper5(
                          type: message[index].isSender
                              ? BubbleType.sendBubble
                              : BubbleType.receiverBubble,
                        ),
                        backGroundColor: message[index].isSender
                            ? Colors.blue
                            : Colors.green,
                        alignment: message[index].isSender
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Text(
                          message[index].text,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    );
                  },
                );
              }
            })),
            Container(
              color: CustomColors.secondcolor_2,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: _message,
                      decoration: InputDecoration(hintText: "Message"),
                    )),
                    IconButton(
                        onPressed: () async {
                          if (_message.text.isNotEmpty) {
                            await ChatService().sendMessageToDatabase(
                                _message.text, widget.groupcode, widget.chatID);
                            _message.clear();

                            context.read<ChatMessageCubit>().getMessages();

                            //_controller
                            //   .jumpTo(_controller.position.maxScrollExtent);
                          }
                        },
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        )),
                  ],
                ),
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

                    if (_controller.hasClients)
                      _controller.jumpTo(_controller.position.maxScrollExtent);
                    return Container();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
