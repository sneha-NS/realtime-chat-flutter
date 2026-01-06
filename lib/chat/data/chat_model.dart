class ChatModel {
  final String id;
  final String lastMessage;
  final List<String> participantNames;

  ChatModel({
    required this.id,
    required this.lastMessage,
    required this.participantNames,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json, String myUserId) {
    final participants = json['participants'] as List;

    final names = participants
        .where((p) => p['_id'] != myUserId)
        .map<String>((p) => p['name'])
        .toList();

    return ChatModel(
      id: json['_id'],
      lastMessage: json['lastMessage'] ?? '',
      participantNames: names,
    );
  }
}
