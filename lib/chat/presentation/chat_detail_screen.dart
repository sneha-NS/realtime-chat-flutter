import 'package:chat_app/chat/data/chat_detail_provider.dart';
import 'package:chat_app/chat/online_users_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChatDetailScreen extends StatelessWidget {
  final String myUserId;
  final String receiverId;
  final String receiverName;

  const ChatDetailScreen({
    super.key,
    required this.myUserId,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  Widget build(BuildContext context) {
    final onlineProvider = Provider.of<OnlineUsersProvider>(context);
    final isOnline = onlineProvider.isUserOnline(receiverId);

    return ChangeNotifierProvider(
      create: (_) => ChatDetailProvider(
        myUserId: myUserId,
        receiverId: receiverId,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(receiverName),
              Text(
                isOnline ? 'Online' : 'Offline',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(child: _MessagesList(myUserId)),
            _MessageInput(),
          ],
        ),
      ),
    );
  }
}


class _MessagesList extends StatelessWidget {
  final String myUserId;
  const _MessagesList(this.myUserId);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatDetailProvider>(context);

    return ListView.builder(
      itemCount: provider.messages.length,
      itemBuilder: (context, index) {
        final msg = provider.messages[index];
        final isMe = msg.senderId == myUserId;

        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg.message,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 6),
                if (isMe)
                  Icon(
                    msg.isRead
                        ? Icons.done_all
                        : msg.isDelivered
                            ? Icons.done_all
                            : Icons.check,
                    size: 16,
                    color: msg.isRead ? Colors.lightBlueAccent : Colors.white70,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class _MessageInput extends StatefulWidget {
  @override
  State<_MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<_MessageInput> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatDetailProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Type a message',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (controller.text.trim().isEmpty) return;

              provider.sendMessage(controller.text.trim());
              controller.clear();
            },
          ),
        ],
      ),
    );
  }
}
