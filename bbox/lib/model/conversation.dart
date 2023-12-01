
import 'dart:convert';

class Conversation {
    String sender;
    String message;
    String id;
    DateTime createdAt;
    DateTime updatedAt;

    Conversation({
        required this.sender,
        required this.message,
        required this.id,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        sender: json["sender"],
        message: json["message"],
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "sender": sender,
        "message": message,
        "_id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}
