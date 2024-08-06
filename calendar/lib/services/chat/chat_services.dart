import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/message.dart';



class ChatServices extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverId, String message) async {
    try {
      // Get current user info
      final String currentUserId = _firebaseAuth.currentUser!.uid;
      final String currentUserEmail =
          _firebaseAuth.currentUser!.email.toString();
      final Timestamp timestamp = Timestamp.now();

      // Create the new message
      Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        timestamp: timestamp,
        message: message,
      );

      // Construct chat room id from the current user id and receiver id to ensure uniqueness
      List<String> ids = [currentUserId, receiverId];
      ids.sort();
      String chatRoomId = ids.join("_");

      // Add the message to the database
      await _firestore
          .collection("chat_rooms")
          .doc(chatRoomId)
          .collection('message')
          .add(newMessage.toMap());

      // Getting the messages
    } catch (error) {
      print('Error sending message: $error');
    }
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('message')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Stream<QuerySnapshot> getVents(String userId) {
  //   List<String> ids = [userId];
  //   ids.sort();
  //   String ventId = ids.toString();

  //   return _firestore
  //       .collection('vents')
  //       .doc(ventId)
  //       .collection('ventMessages')
  //       .orderBy('timestamp', descending: false)
  //       .snapshots();
  // }

  Stream<QuerySnapshot> getVents([String? userId]) {
  CollectionReference ventsCollection = _firestore.collection('vents');
  Query query = ventsCollection;

  if (userId != null) {
    List<String> ids = [userId];
    ids.sort();
    String ventId = ids.toString();
    query = ventsCollection.doc(ventId).collection('ventMessages');
  }

  return query.orderBy('timestamp', descending: true).snapshots();
}
}

