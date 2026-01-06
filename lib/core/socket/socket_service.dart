import 'package:chat_app/core/config/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static IO.Socket? _socket;
  static bool _isConnected = false;

  static void connect(String userId) {
    if (_isConnected) return; 

    _socket = IO.io(
  AppConfig.baseUrl,
  IO.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .build(),
);


    _socket!.connect();

    _socket!.onConnect((_) {
      debugPrint('🟢 Socket connected');
      _isConnected = true;
      _socket!.emit('user_online', userId);
    });

    _socket!.onDisconnect((_) {
      debugPrint('🔴 Socket disconnected');
      _isConnected = false;
    });
  }

  // 🔹 Send message
  static void sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) {
    if (_socket == null) return;

    _socket!.emit('send_message', {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
    });
  }

  // 🔹 Listen for incoming messages
  static void onReceiveMessage(void Function(dynamic data) callback) {
    _socket?.off('receive_message'); // ✅ prevent duplicate listeners
    _socket?.on('receive_message', callback);
  }

  // 🔹 Typing indicator
  static void onTyping(void Function() callback) {
    _socket?.off('typing');
    _socket?.on('typing', (_) => callback());
  }

  // 🔹 Online users list
  static void onOnlineUsers(void Function(List<String>) callback) {
    _socket?.off('online_users');
    _socket?.on('online_users', (data) {
      final users = List<String>.from(data);
      callback(users);
    });
  }

  // 🔹 Read receipt (✔✔ seen)
  static void onMessageSeen(void Function(String messageId) callback) {
    _socket?.off('message_seen');
    _socket?.on('message_seen', (messageId) {
      callback(messageId);
    });
  }

  // 🔹 Disconnect socket (logout / app close)
  static void disconnect() {
    if (_socket == null) return;

    _socket!.disconnect();
    _socket!.dispose();
    _socket = null;
    _isConnected = false;
  }
}
