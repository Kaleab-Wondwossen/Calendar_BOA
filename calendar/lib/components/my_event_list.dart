import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'my_card_builder.dart';

class EventList extends StatefulWidget {
  const EventList({super.key});

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
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

          // Filter documents to include only those with the correct user ID and future dates
          List<DocumentSnapshot> userDocuments = documents.where((document) {
            // Check if the event belongs to the current user
            bool isCurrentUserEvent = document['ID'] == currentUserId;

            // Parse event date
            DateTime eventDate = DateTime.parse(document['Date']);

            // Include events that have eventDate after today
            bool isFutureEvent = eventDate.isAfter(DateTime.now());

            return isCurrentUserEvent && isFutureEvent;
          }).toList();

          // Sort documents by eventDate in ascending order
          userDocuments.sort((a, b) {
            DateTime eventDateA = DateTime.parse(a['Date']);
            DateTime eventDateB = DateTime.parse(b['Date']);
            return eventDateA.compareTo(eventDateB);
          });

          if (userDocuments.isEmpty) {
            return Center(
              child: Text(
                "Oops, you have no events",
                style:
                    GoogleFonts.acme(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: userDocuments.map((document) {
                String id = document['EventTitle'];
                String message = document['EventDescription'];
                String docID = document.id;
                String date = document['Date'];

                 String eventNotes = document['notes'];
                                  bool notesExist = eventNotes != null &&
                                      eventNotes.isNotEmpty;

                                  if (notesExist) {
                                    print(
                                        'Notes field has content: $eventNotes');
                                  } else {
                                    print(
                                        'Notes field is empty or not available.');
                                  }

                // Parse event date
                DateTime eventDate = DateTime.parse(document['Date']);

                // Calculate days difference
                int daysDifference =
                    eventDate.difference(DateTime.now()).inDays;

                // Determine color based on days difference
                Color color;
                if (daysDifference <= 5) {
                  color = const Color.fromARGB(255, 233, 176, 64);
                } else if (daysDifference <= 15) {
                  color = const Color.fromARGB(255, 233, 176, 64);
                } else {
                  color = const Color.fromARGB(255, 98, 201, 102);
                }

                return CardBuilder(
                  title: id,
                  description: message,
                  color: color,
                  docId: docID,
                  date: date,
                  docuId: document.id,
                  notesExist: notesExist,
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
