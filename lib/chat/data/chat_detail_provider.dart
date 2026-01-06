import 'package:flutter/material.dart';
import 'package:chat_app/chat/data/message_model.dart';
import 'package:chat_app/core/socket/socket_service.dart';

class ChatDetailProvider extends ChangeNotifier {
  final String myUserId;
  final String receiverId;

  List<MessageModel> messages = [];
  bool isTyping = false;

  ChatDetailProvider({
    required this.myUserId,
    required this.receiverId,
  }) {
    SocketService.onReceiveMessage(_onMessageReceived);
    SocketService.onTyping(_onTyping);
    SocketService.onMessageSeen(_onMessageSeen);
  }

  // 🔹 Receive new message
  void _onMessageReceived(dynamic data) {
    messages.add(MessageModel.fromJson(data));
    notifyListeners();
  }

  // 🔹 Typing indicator
  void _onTyping() {
    isTyping = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      isTyping = false;
      notifyListeners();
    });
  }

  // 🔹 Send message
  void sendMessage(String text) {
    SocketService.sendMessage(
      senderId: myUserId,
      receiverId: receiverId,
      message: text,
    );
  }

  // 🔹 Read receipt handler (✔✔ blue)
  void _onMessageSeen(String messageId) {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      messages[index].isRead = true;
      notifyListeners();
    }
  }
}
