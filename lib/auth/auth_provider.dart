import 'package:chat_app/core/socket/socket_service.dart';
import 'package:flutter/material.dart';
import '../core/storage/token_storage.dart';
import 'data/auth_api.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isLoggedIn = false;

  AuthProvider() {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final token = await TokenStorage.getToken();
    isLoggedIn = token != null;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final userId = await AuthApi.login(email, password);
      SocketService.connect(userId);
      isLoggedIn = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

Future<void> registerAndLogin(
  String name,
  String email,
  String password,
) async {
  isLoading = true;
  notifyListeners();

  try {
    // 1️⃣ Register user
    await AuthApi.register(name, email, password);

    // 2️⃣ Login immediately
    final userId = await AuthApi.login(email, password);

    // 3️⃣ Connect socket
    SocketService.connect(userId);

    isLoggedIn = true;
  } finally {
    // 🔥 THIS fixes the infinite spinner
    isLoading = false;
    notifyListeners();
  }
}


  Future<void> logout() async {
    await TokenStorage.clearToken();
    isLoggedIn = false;
    notifyListeners();
  }
}
