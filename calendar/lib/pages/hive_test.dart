import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveCRUD {
  final _myBox = Hive.box('Events');

  void writeData(List data) {
    int index = _myBox.length; // Use the current length of the box to get the next index
    _myBox.put(index, data);
    print(_myBox.get(index));
  }

  List<List> readData(int key) {
    return _myBox.get(key);
  }

  void deleteData(int key) {
    _myBox.delete(key);
  }
}

class DraggableFabExample extends StatefulWidget {
  @override
  _DraggableFabExampleState createState() => _DraggableFabExampleState();
}

class _DraggableFabExampleState extends State<DraggableFabExample> {
  late Offset offset;
  late TextEditingController eventTitleController;
  late TextEditingController eventDescriptionController;
  List<Map<String, dynamic>> events = [];

  @override
  void initState() {
    super.initState();
    offset = Offset(50, 50); // Initial position of the FAB
    eventTitleController = TextEditingController();
    eventDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    eventTitleController.dispose();
    eventDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: offset.dx,
            top: offset.dy,
            child: Draggable(
              feedback: FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 233, 176, 64),
                onPressed: () {},
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.black,
                ),
              ),
              childWhenDragging: Container(),
              onDragEnd: (details) {
                setState(() {
                  offset = details.offset;
                });
              },
              child: FloatingActionButton(
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
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: eventTitleController,
                                decoration: const InputDecoration(
                                  labelText: 'Event Title',
                                  fillColor: Colors.black,
                                  focusColor: Colors.black,
                                ),
                              ),
                              TextField(
                                controller: eventDescriptionController,
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
                              style: GoogleFonts.acme(
                                  color: Colors.black, fontSize: 15),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              print(eventDescriptionController.text);
                              print(eventTitleController.text);
                              setState(() {
                                events.add({
                                  'title': eventTitleController.text,
                                  'description': eventDescriptionController.text,
                                });
                              });
                              DateTime today = DateTime.now();
                              HiveCRUD hiveCRUD = HiveCRUD();
                              hiveCRUD.writeData([
                                eventTitleController.text,
                                eventDescriptionController.text,
                                today.toString()
                              ]);
                              eventDescriptionController.clear();
                              eventTitleController.clear();
                            },
                            child: Text(
                              'Add',
                              style: GoogleFonts.acme(
                                  color: Colors.black, fontSize: 15),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            top: 10.0,
            left: 10.0,
            right: 10.0,
            bottom: 10.0,
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return ListTile(
                  title: Text(event['title']),
                  subtitle: Text(event['description']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('Events');
  runApp(MaterialApp(home: DraggableFabExample()));
}
