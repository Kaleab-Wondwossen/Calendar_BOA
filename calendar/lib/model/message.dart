import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final bool hasNewMessage;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.timestamp,
    required this.message,
    this.hasNewMessage = true,
  });

  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "senderEmail": senderEmail,
      "receiverId": receiverId,
      "timestamp": timestamp,
      "message": message,
      "hasNewMessage": hasNewMessage
    };
  }
}
