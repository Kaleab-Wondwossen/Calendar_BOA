import 'package:calendar/pages/events_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../components/my_card_builder.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage({super.key});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const Events()));
            },
            icon: const Icon(Icons.arrow_back_ios)),
            title:  const Text(
                "M E E T I N G S",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Lottie.asset('images/meetings.json', repeat: false),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('Events').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> documents = snapshot.data!.docs;

                    // Get the current user ID
                    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                    final String currentUserId = firebaseAuth.currentUser!.uid;

                    // Filter documents to include only those with the correct user ID and future dates
                    List<DocumentSnapshot> userDocuments =
                        documents.where((document) {
                      // Check if the event belongs to the current user
                      bool isCurrentUserEvent = document['ID'] == currentUserId;

                      // Parse event date
                      DateTime eventDate = DateTime.parse(document['Date']);

                      // Include events that have eventDate after today
                      bool isFutureEvent = eventDate.isAfter(DateTime.now());

                      // Check if title contains "birthday" case-insensitively
                      bool isBirthdayEvent = document['EventTitle']
                          .toString()
                          .toLowerCase()
                          .contains('meetings');

                      return isCurrentUserEvent &&
                          isFutureEvent &&
                          isBirthdayEvent;
                    }).toList();

                    // Sort documents by eventDate in ascending order
                    userDocuments.sort((a, b) {
                      DateTime eventDateA = DateTime.parse(a['Date']);
                      DateTime eventDateB = DateTime.parse(b['Date']);
                      return eventDateA.compareTo(eventDateB);
                    });

                    // Print titles of birthday events
                    userDocuments.forEach((document) {
                      String id = document['EventTitle'];
                      print('Meeting Event Title: $id');
                    });

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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
