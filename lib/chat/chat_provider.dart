import 'package:flutter/material.dart';
import 'data/chat_api.dart';
import 'data/chat_model.dart';

class ChatProvider extends ChangeNotifier {
  bool isLoading = false;
  List<ChatModel> chats = [];

  Future<void> loadChats(String myUserId) async {
    isLoading = true;
    notifyListeners();

    final data = await ChatApi.getChats();
    chats = data
        .map<ChatModel>((c) => ChatModel.fromJson(c, myUserId))
        .toList();

    isLoading = false;
    notifyListeners();
  }
}
