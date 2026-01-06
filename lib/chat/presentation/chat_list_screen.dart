import 'package:chat_app/chat/online_users_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../chat_provider.dart';

class ChatListScreen extends StatefulWidget {
  final String myUserId;
  const ChatListScreen({super.key, required this.myUserId});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ChatProvider>(
      context,
      listen: false,
    ).loadChats(widget.myUserId);
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final onlineProvider = Provider.of<OnlineUsersProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: chatProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: chatProvider.chats.length,
              itemBuilder: (context, index) {
                final chat = chatProvider.chats[index];

                // ✅ FIX: compute isOnline HERE
                final isOnline = onlineProvider.isUserOnline(
                  chat.participantNames.first, // receiverId
                );

                return ListTile(
                  leading: Stack(
                    children: [
                      const CircleAvatar(child: Icon(Icons.person)),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: isOnline ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Text(chat.participantNames.join(', ')),
                  subtitle: Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    // navigate to chat detail (next)
                  },
                );
              },
            ),
    );
  }
}
