import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewTableCalendar extends StatefulWidget {
  const NewTableCalendar({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<NewTableCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<DateTime, List<dynamic>> _events = {};

  @override
  void initState() {
    super.initState();
    _fetchEventsFromFirebase();
    String currentUserId = _firebaseAuth.currentUser!.uid;
  }

  void _fetchEventsFromFirebase() async {
    // Fetch events from Firestore and update the _events map
    final snapshot = await _firestore.collection('events').get();
    Map<DateTime, List<dynamic>> events = {};
    for (var doc in snapshot.docs) {
      DateTime date = (doc['date'] as Timestamp).toDate();
      if (!events.containsKey(date)) {
        events[date] = [];
      }
      events[date]?.add(doc.data());
    }
    setState(() {
      _events = events;
    });
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _showAddEventDialog() {
    String title = '';
    String description = '';
    String category = '';
    String notes = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Event Title'),
              onChanged: (value) {
                title = value;
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Event Description'),
              onChanged: (value) {
                description = value;
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Category'),
              onChanged: (value) {
                category = value;
              },
            ),
            TextButton(
              onPressed: () {
                _showNotesDialog((noteText) {
                  notes = noteText;
                });
              },
              child: const Text('Add Notes'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _firestore.collection('events').add({
                'title': title,
                'description': description,
                'category': category,
                'notes': notes,
                'date': _selectedDay,
              });
              Navigator.of(context).pop();
              _fetchEventsFromFirebase(); // Refresh events
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showNotesDialog(ValueChanged<String> onNotesSaved) {
    String notes = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Notes'),
        content: TextField(
          decoration: const InputDecoration(labelText: 'Notes'),
          onChanged: (value) {
            notes = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onNotesSaved(notes);
            },
            child: const Text('Save Notes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar App'),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
            eventLoader: _getEventsForDay,
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    bottom: 1,
                    child: Container(
                      width: 7.0,
                      height: 7.0,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _getEventsForDay(_selectedDay ?? _focusedDay).length,
              itemBuilder: (context, index) {
                var event =
                    _getEventsForDay(_selectedDay ?? _focusedDay)[index];
                return ListTile(
                  title: Text(event['title'] ?? 'No Title'),
                  subtitle: Text(event['description'] ?? 'No Description'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
