import 'package:calendar/components/my_card_builder_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../model/events.dart';
import '../services/FireStore/fire_store.dart';

class AdminAddEvent extends StatefulWidget {
  const AdminAddEvent({super.key});

  @override
  State<AdminAddEvent> createState() => _AdminAddEventState();
}

class _AdminAddEventState extends State<AdminAddEvent> {
  late DateTime day;
  Map<DateTime, List<Events>> evenets = {};
  TextEditingController eventDescriptionCOntroller = TextEditingController();
  TextEditingController eventTitleCOntroller = TextEditingController();
  late DateTime hour;
  late DateTime minute;
  late DateTime month;
  late final ValueNotifier<List<Events>> selectedEvent;
  late DateTime today;
  late DateTime year;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    year = DateTime(today.year);
    month = DateTime(today.year, today.month);
    day = DateTime(today.year, today.month, today.day);
    hour = DateTime(today.year, today.month, today.day, today.hour);
    minute =
        DateTime(today.year, today.month, today.day, today.hour, today.minute);
    selectedEvent = ValueNotifier(_getEventsForDay(today));
    selectedEvent.value = _getEventsForDay(today);
  }

  void onDaySelected(DateTime day, DateTime focusedDate) {
    setState(() {
      today = day;
    });
  }

  List<Events> _getEventsForDay(DateTime day) {
    return evenets[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 233, 176, 64),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  scrollable: true,
                  title: Text(
                    'Add Event',
                    style: GoogleFonts.acme(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Container(
                    //color: const Color.fromARGB(255, 245, 222, 174), // Change this to your preferred color
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: eventTitleCOntroller,
                          decoration: const InputDecoration(
                              labelText: 'Event Title',
                              fillColor: Colors.black,
                              focusColor: Colors.black),
                        ),
                        TextField(
                          controller: eventDescriptionCOntroller,
                          decoration: const InputDecoration(
                            labelText: 'Event Description',
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style:
                            GoogleFonts.acme(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        evenets.addAll({
                          today: [
                            Events(eventTitleCOntroller.text,
                                eventDescriptionCOntroller.text)
                          ]
                        });

                        final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                        final String currentUserId =
                            firebaseAuth.currentUser!.uid;

                        selectedEvent.value = _getEventsForDay(today);
                        String date = DateFormat('yyyy-MM-dd').format(today);
                        //ignore: no_leading_underscores_for_local_identifiers
                        FireStoreServices _firestoreservices =
                            FireStoreServices();
                        _firestoreservices.addEvents(
                            eventTitleCOntroller.text,
                            eventDescriptionCOntroller.text,
                            date,
                            currentUserId);
                        eventDescriptionCOntroller.clear();
                        eventTitleCOntroller.clear();
                      },
                      child: Text(
                        'Add',
                        style:
                            GoogleFonts.acme(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  ],
                );
              });
        },
        child: const Icon(
          Icons.add_rounded,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        title: Text("Add Events to Calendar", style: GoogleFonts.acme(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20)
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              locale: "en_US",
              rowHeight: 43,
              headerStyle: const HeaderStyle(
                  formatButtonVisible: true, titleCentered: true),
              calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Color.fromARGB(255, 245, 222, 174),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Color.fromARGB(255, 233, 176, 64),
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  selectedTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Color.fromARGB(255, 233, 176, 64),
                    shape: BoxShape.circle,
                  ),
                  markerSize: 10.0),
              availableGestures: AvailableGestures.all,
              focusedDay: today,
              eventLoader: _getEventsForDay,
              selectedDayPredicate: (day) => isSameDay(day, today),
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 10, 16),
              onDaySelected: onDaySelected,
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 250, 10),
                child: Text(
                  "Added Events",
                  style: GoogleFonts.acme(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('AdminEvents').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> documents = snapshot.data!.docs;

                    // Get the current user ID
                    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                    final String currentUserId = firebaseAuth.currentUser!.uid;

                    // Filter documents to include only those with the correct user ID
                    List<DocumentSnapshot> userDocuments =
                        documents.where((document) {
                      bool isCurrentUserEvent =
                          document['ID'] == currentUserId;
                      return isCurrentUserEvent;
                    }).toList();

                    // Sort documents by eventDate in ascending order
                    userDocuments.sort((a, b) {
                      DateTime eventDateA = DateTime.parse(a['Date']);
                      DateTime eventDateB = DateTime.parse(b['Date']);
                      return eventDateA.compareTo(eventDateB);
                    });

                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 0), // Adjust the left padding as needed
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: userDocuments.map((document) {
                          String id = document['EventTitle'];
                          String message = document['EventDescription'];
                          DateTime eventDate = DateTime.parse(document['Date']);
                          String docID = document.id;
                          String date = document['Date'];
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

                          return CardBuilderAdmin(
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
    );
  }
}
