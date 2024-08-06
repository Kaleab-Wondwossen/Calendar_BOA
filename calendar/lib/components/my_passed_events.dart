import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'my_card_builder.dart';

class MyPassedEvents extends StatefulWidget {
  const MyPassedEvents({super.key});

  @override
  State<MyPassedEvents> createState() => _MyPassedEventsState();
}

class _MyPassedEventsState extends State<MyPassedEvents> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Events').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> documents = snapshot.data!.docs;

          // Get the current user ID
          final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
          final String currentUserId = firebaseAuth.currentUser!.uid;

          // Filter documents to include only those with the correct user ID
          List<DocumentSnapshot> userDocuments = documents.where((document) {
            bool isCurrentUserEvent = document['ID'] == currentUserId;
            return isCurrentUserEvent;
          }).toList();

          // Filter documents to only include past events
          List<DocumentSnapshot> pastDocuments =
              userDocuments.where((document) {
            DateTime eventDate = DateTime.parse(document['Date']);
            // Calculate days difference
            int daysDifference = eventDate.difference(DateTime.now()).inDays;
            return daysDifference < 0; // Filter for past events
          }).toList();
          return Padding(
            padding: const EdgeInsets.only(
                left: 0), // Adjust the left padding as needed
            child: pastDocuments.isEmpty
                ? Center(
                    child: Text(
                      'OOPS!! You have deleted your past events!!',
                      style: GoogleFonts.acme(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  )
                : Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: pastDocuments.map((document) {
                      String id = document['EventTitle'];
                      String message = document['EventDescription'];
                      // Parse the date string to DateTime
                      DateTime eventDate = DateTime.parse(document['Date']);
                      String date = document['Date'];
                      // Calculate days difference
                      int daysDifference =
                          eventDate.difference(DateTime.now()).inDays;
                      String docID = document.id;
                      // Determine color based on days difference
                      Color color;
                      if (daysDifference <= 15) {
                        color = const Color.fromARGB(255, 241, 120, 117);
                      } else {
                        color = const Color.fromARGB(255, 98, 201, 102);
                      }

                      return CardBuilder(
                        title: id,
                        description: message,
                        color: color,
                        date: date,
                        showEditIcon: false,
                        docId: docID,
                      );
                    }).toList(),
                  ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
