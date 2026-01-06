class MessageModel {
  final String id;
  final String senderId;
  final String message;
  final DateTime createdAt;
  bool isDelivered;
  bool isRead;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.message,
    required this.createdAt,
    required this.isDelivered,
    required this.isRead,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
      senderId: json['senderId'],
      message: json['message'],
      createdAt: DateTime.parse(json['createdAt']),
      isDelivered: json['isDelivered'] ?? false,
      isRead: json['isRead'] ?? false,
    );
  }
}
