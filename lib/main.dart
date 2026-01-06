import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/auth_provider.dart';
import 'auth/presentation/login_screen.dart';
import 'home/home_screen.dart';
import 'chat/chat_provider.dart';
import 'chat/online_users_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => OnlineUsersProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: authProvider.isLoggedIn
                ? const HomeScreen()
                : const LoginScreen(),
          );
        },
      ),
    );
  }
}
