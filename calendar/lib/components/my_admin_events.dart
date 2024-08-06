import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'my_card_builder.dart';

class AdminEvents extends StatefulWidget {
  const AdminEvents({super.key});

  @override
  State<AdminEvents> createState() => _AdminEventsState();
}

class _AdminEventsState extends State<AdminEvents> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('AdminEvents').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> documents = snapshot.data!.docs;

          // Filter out past events
          DateTime now = DateTime.now();
          documents = documents.where((document) {
            DateTime eventDate = DateTime.parse(document['Date']);
            return eventDate.isAfter(now);
          }).toList();

          // Sort documents by eventDate in ascending order
          documents.sort((a, b) {
            DateTime eventDateA = DateTime.parse(a['Date']);
            DateTime eventDateB = DateTime.parse(b['Date']);
            return eventDateA.compareTo(eventDateB);
          });

          return Padding(
            padding: const EdgeInsets.only(left: 0), // Adjust the left padding as needed
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: documents.map((document) {
                String id = document['EventTitle'];
                String message = document['EventDescription'];
                DateTime eventDate = DateTime.parse(document['Date']);
                String docID = document.id;
                String date = document['Date'];

                // Calculate days difference
                int daysDifference = eventDate.difference(now).inDays;

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
                  showDeleteIcon: false,
                  showEditIcon: false,
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
