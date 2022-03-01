import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refriend/database/database_chat.dart';
import 'package:refriend/models/messages.dart';
import 'package:refriend/services/group_service.dart';

class ChatMessageCubit extends Cubit<List<Message>> {
  final _dataService = DatabaseChat();

  ChatMessageCubit(this.groupCode, this.chatID) : super([]);
  final groupCode;
  final chatID;
  void getMessages() async =>
      emit(await _dataService.getMessagesChat(groupCode, chatID));

  @override
  void onChange(Change<List<Message>> change) {
    super.onChange(change);
  }



}
