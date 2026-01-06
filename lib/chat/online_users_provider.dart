import 'package:flutter/material.dart';
import '../core/socket/socket_service.dart';

class OnlineUsersProvider extends ChangeNotifier {
  List<String> onlineUserIds = [];

  OnlineUsersProvider() {
    SocketService.onOnlineUsers((users) {
      onlineUserIds = users;
      notifyListeners();
    });
  }

  bool isUserOnline(String userId) {
    return onlineUserIds.contains(userId);
  }
}
