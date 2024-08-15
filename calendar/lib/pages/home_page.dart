// ignore_for_file: avoid_print
import 'dart:async';
import 'package:abushakir/abushakir.dart';
import 'package:calendar/components/my_carousel_slider.dart';
import 'package:calendar/components/my_drawer.dart';
import 'package:calendar/components/my_nav_bar.dart';
import 'package:calendar/pages/admin_home_page.dart';
import 'package:calendar/pages/home_page_user.dart';
import 'package:calendar/pages/inbox_page.dart';
import 'package:calendar/pages/local_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ethiopian_calendar/ethiopian_date_converter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../components/my_card_builder.dart';
import '../model/events.dart';
import '../services/FireStore/fire_store.dart';
import 'flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String chatRoomId;
  late String currentUserEmail;
  late String currentUserID;
  late DateTime day;
  DateTime ethioDate =
      EthiopianDateConverter.convertToEthiopianDate(DateTime.now());

  List<String> ethiopianDayNames = [
    'እሑድ', // Sunday
    'ሰኞ', // Monday
    'ማክሰኞ', // Tuesday
    'ረቡዕ', // Wednesday
    'ሐሙስ', // Thursday
    'ዓርብ', // Friday
    'ቅዳሜ', // Saturday
  ];

  List<String> ethiopianMonthNames = [
    'መስከረም',
    'ጥቅምት',
    'ህዳር',
    'ታህሳስ',
    'ጥር',
    'የካቲት',
    'መጋቢት',
    'ሚይዚያ',
    'ግንቦት',
    'ሰኔ',
    'ሐምሌ',
    'ነሐሴ',
    'ጳጉሜ',
  ];

  Map<DateTime, List<Events>> evenets = {};
  TextEditingController eventDescriptionCOntroller = TextEditingController();
  TextEditingController eventTitleCOntroller = TextEditingController();
  late DateTime hour;
  bool isEthiopian = true; // State variable to toggle calendar type
  late DateTime minute;
  late DateTime month;
  late final ValueNotifier<List<Events>> selectedEvent;
  late DateTime today;
  late String username;
  late DateTime year;
  String selectedCategory = '';
  String dropdownValue = 'Celebration';

  CalendarFormat _calendarFormat = CalendarFormat.month;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // ignore: unused_field
  bool _hasUnreadMessages = false;

  @override
  void initState() {
    super.initState();
    checkUnreadMessages();
    today = DateTime.now();
    year = DateTime(today.year);
    month = DateTime(today.year, today.month);
    day = DateTime(today.year, today.month, today.day);
    hour = DateTime(today.year, today.month, today.day, today.hour);
    minute =
        DateTime(today.year, today.month, today.day, today.hour, today.minute);
    selectedEvent = ValueNotifier(_getEventsForDay(today));
    selectedEvent.value = _getEventsForDay(today);
    currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    currentUserID = _firebaseAuth.currentUser!.uid.toString();
    int endIndex = currentUserEmail.indexOf(RegExp(r'[.@]'));
    username = (endIndex == -1)
        ? currentUserEmail
        : currentUserEmail.substring(0, endIndex);
    List<String> ids = ["qOKnO7ffQYPnwA7N98M4yURQbH33", currentUserID];
    ids.sort();
    chatRoomId = ids.join("_");
    NotificationService().initNotification();
    scheduleDailyEventCheck();
  }

  EtDatetime convertToEthiopianDate(DateTime date) {
    return EtDatetime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch);
  }

  DateTime convertToGregorianDate(EtDatetime etDate) {
    return DateTime(etDate.year, etDate.month, etDate.day);
  }

  void scheduleDailyEventCheck() {
    final now = DateTime.now();
    final timeToSchedule = TimeOfDay(hour: 8, minute: 0);

    // Calculate the difference between now and the time to schedule
    final nowMinutes = now.hour * 60 + now.minute;
    final scheduleMinutes = timeToSchedule.hour * 60 + timeToSchedule.minute;
    final initialDelay = scheduleMinutes > nowMinutes
        ? scheduleMinutes - nowMinutes
        : 24 * 60 - (nowMinutes - scheduleMinutes);

    Future.delayed(Duration(minutes: initialDelay), () async {
      await checkForTodayEvents();
      // Repeat daily
      Timer.periodic(Duration(days: 1), (timer) async {
        await checkForTodayEvents();
      });
    });
  }

  Future<void> checkForTodayEvents() async {
    // Get the current user ID
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final String currentUserId = firebaseAuth.currentUser!.uid;

    // Get today's date
    final today = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(today);

    // Query Firestore for today's events for the current user
    final eventsQuery = FirebaseFirestore.instance
        .collection('Events')
        .where('ID', isEqualTo: currentUserId)
        .where('Date', isEqualTo: formattedDate);

    final querySnapshot = await eventsQuery.get();

    if (querySnapshot.docs.isNotEmpty) {
      // Show notification if there are events for today
      NotificationService().showNotification(
        'Today\'s Events',
        'You have events scheduled for today!',
      );
    }
  }

  void checkUnreadMessages() async {
    bool unreadMessages = await hasUnreadMessages();
    setState(() {
      _hasUnreadMessages = unreadMessages;
    });
  }

  void onDaySelected(DateTime day, DateTime focusedDate) {
    setState(() {
      today = day;
    });
  }

  String getHeaderText(DateTime date) {
    if (isEthiopian) {
      final ethiopianDate = EthiopianDateConverter.convertToEthiopianDate(date);
      final ethiopianMonth = ethiopianDate.month;
      final ethiopianYear = ethiopianDate.year;
      return '${ethiopianMonthNames[ethiopianMonth - 1]} $ethiopianYear';
    } else {
      return DateFormat.yMMMM().format(date);
    }
  }

  Future<bool> hasUnreadMessages() async {
    String currentUserId = _firebaseAuth.currentUser!.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chat_rooms')
        .where('receiverId', isEqualTo: currentUserId)
        .where('hasNewMessage', isEqualTo: true)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePageUser()),
    );
  }

  List<Events> _getEventsForDay(DateTime day) {
    return evenets[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0, 160, 0),
        child: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 233, 176, 64),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                String dropdownValue =
                    'Celebration'; // Initialize with default value
                return StatefulBuilder(
                  builder: (context, setState) {
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
                              controller: eventTitleCOntroller,
                              decoration: const InputDecoration(
                                labelText: 'Event Title',
                                fillColor: Colors.black,
                                focusColor: Colors.black,
                              ),
                            ),
                            TextField(
                              controller: eventDescriptionCOntroller,
                              decoration: const InputDecoration(
                                labelText: 'Event Description',
                              ),
                            ),
                            DropdownButton<String>(
                              value: dropdownValue,
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(
                                height: 2,
                                color: Colors.black,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                  selectedCategory =
                                      newValue; // Store selected category
                                });
                              },
                              items: <String>[
                                'Celebration',
                                'Meeting',
                                'Out Door Activities',
                                'People'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
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
                            print(eventDescriptionCOntroller.toString());
                            print(eventTitleCOntroller.toString());
                            evenets.addAll({
                              today: [
                                Events(
                                  eventTitleCOntroller.text,
                                  eventDescriptionCOntroller.text,
                                )
                              ]
                            });

                            final FirebaseAuth firebaseAuth =
                                FirebaseAuth.instance;
                            final String currentUserId =
                                firebaseAuth.currentUser!.uid;

                            selectedEvent.value = _getEventsForDay(today);
                            String date =
                                DateFormat('yyyy-MM-dd').format(today);
                            FireStoreServices _firestoreservices =
                                FireStoreServices();
                            _firestoreservices.add(
                                eventTitleCOntroller.text,
                                eventDescriptionCOntroller.text,
                                date,
                                currentUserId,
                                selectedCategory // Add the selected category
                                );
                            eventDescriptionCOntroller.clear();
                            eventTitleCOntroller.clear();
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
            );
          },
          child: const Icon(
            Icons.add_rounded,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.2,
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 233, 176, 64)),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 0.01, 0, 0, 0),
                      child: Builder(
                          builder: (context) => IconButton(
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              icon: Icon(
                                Icons.menu,
                                color: Colors.black,
                              ))),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 60,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0,
                                MediaQuery.of(context).size.width * 0.2, 0),
                            child: Image.asset(
                              "images/white.png",
                              width: 170,
                              height: 100,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 0.1, 0, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (currentUserEmail == "iamadmin@gmail.com")
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AdminHomePage()));
                                },
                                icon: Icon(
                                  Icons.swap_horiz,
                                  color: Colors.black,
                                  size: 30,
                                ))
                          else
                            Text("            "),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEthiopian = !isEthiopian;
                                });
                              },
                              child: isEthiopian
                                  ? Text(
                                      "G.C",
                                      style: GoogleFonts.acme(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : Text(
                                      "ዓ.ም",
                                      style: GoogleFonts.acme(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              isEthiopian
                                  ? ethiopianMonthNames[EthiopianDateConverter
                                              .convertToEthiopianDate(today)
                                          .month -
                                      1]
                                  : DateFormat.MMM().format(today),
                              style: GoogleFonts.acme(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              " ${isEthiopian ? EthiopianDateConverter.convertToEthiopianDate(today).day : DateFormat.d().format(today)}",
                              style: GoogleFonts.acme(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                          child: Text(
                            isEthiopian
                                ? ethiopianDayNames[(EthiopianDateConverter
                                                .convertToEthiopianDate(today)
                                            .weekday +
                                        2) %
                                    7]
                                : DateFormat.EEEE().format(today),
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  Column(
                    children: [
                      Text(
                        "${username}",
                        style: GoogleFonts.acme(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Welcome to your calendar",
                          style: GoogleFonts.acme(
                            color: Colors.black,
                            fontSize: 12,
                          ))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.person_rounded,
                        color: Color.fromARGB(255, 233, 176, 64),
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
              TableCalendar(
                locale: "en_US",
                rowHeight: 43,
                headerStyle: HeaderStyle(
                  formatButtonVisible: true,
                  titleCentered: true,
                  formatButtonShowsNext: false,
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.black),
                  weekendStyle: TextStyle(color: Colors.red),
                  dowTextFormatter: (date, locale) {
                    if (isEthiopian) {
                      return ethiopianDayNames[(date.weekday % 7)];
                    } else {
                      return DateFormat.E(locale).format(date);
                    }
                  },
                ),
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
                  markerSize: 10.0,
                ),
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
                calendarBuilders: CalendarBuilders(
                  headerTitleBuilder: (context, date) {
                    return Container(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          getHeaderText(date),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                  defaultBuilder: (context, date, _) {
                    String displayDate;
                    if (isEthiopian) {
                      final etDate =
                          EthiopianDateConverter.convertToEthiopianDate(date);
                      displayDate = '${etDate.day}';
                    } else {
                      displayDate = '${date.day}';
                    }
                    return Center(
                      child: Text(
                        displayDate,
                        style: GoogleFonts.acme(color: Colors.black),
                      ),
                    );
                  },
                  selectedBuilder: (context, date, _) {
                    String displayDate;
                    if (isEthiopian) {
                      final etDate =
                          EthiopianDateConverter.convertToEthiopianDate(date);
                      displayDate = '${etDate.day}';
                    } else {
                      displayDate = '${date.day}';
                    }
                    return Container(
                      padding: EdgeInsets.fromLTRB(24, 0, 0, 0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 233, 176, 64),
                        shape: BoxShape.circle,
                      ),
                      width: 100,
                      height: 100,
                      child: Text(
                        displayDate,
                        style: GoogleFonts.acme(color: Colors.black),
                      ),
                    );
                  },
                  todayBuilder: (context, date, _) {
                    String displayDate;
                    if (isEthiopian) {
                      final etDate =
                          EthiopianDateConverter.convertToEthiopianDate(date);
                      displayDate = '${etDate.day}';
                    } else {
                      displayDate = '${date.day}';
                    }
                    return Container(
                      padding: EdgeInsets.fromLTRB(24, 18, 0, 0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 245, 222, 174),
                        shape: BoxShape.circle,
                      ),
                      width: 100,
                      height: 100,
                      child: Text(
                        displayDate,
                        style: GoogleFonts.acme(color: Colors.black),
                      ),
                    );
                  },
                ),
              ),
              if (!isEthiopian)
                Text(
                  DateFormat('yyyy-MM-dd').format(
                    EthiopianDateConverter.convertToEthiopianDate(today),
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                )
              else
                Text(
                  DateFormat('yyyy-MM-dd').format(today),
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chat_rooms')
                    .doc(chatRoomId)
                    .collection('message')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var messages = snapshot.data?.docs;

                  if (messages == null || messages.isEmpty) {
                    return Center(
                        child: Text('Admin Don\'t Recive Messages!!'));
                  }

                  bool hasNewMessages = false;

                  for (var message in messages) {
                    if (message['hasNewMessage'] == true) {
                      hasNewMessages = true;
                      break;
                    }
                  }

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    height: 35,
                    child: Stack(
                      children: [
                        // Your chat UI here
                        if (hasNewMessages)
                          Positioned(
                            top: 0,
                            right: 160,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              color: Colors.red,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatPage()));
                                },
                                child: Text(
                                  'New Messages',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10, 270, 10),
                child: Text(
                  "Today's Event!!",
                  style: GoogleFonts.acme(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SingleChildScrollView(
                // reverse: true,
                scrollDirection: Axis.horizontal,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Events')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> documents = snapshot.data!.docs;

                      // Get the current user ID
                      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                      final String currentUserId =
                          firebaseAuth.currentUser!.uid;

                      // Filter documents to include only today's events with the correct user ID
                      List<DocumentSnapshot> todaysDocuments =
                          documents.where((document) {
                        DateTime eventDate = DateTime.parse(document['Date']);
                        bool isEventToday =
                            eventDate.year == DateTime.now().year &&
                                eventDate.month == DateTime.now().month &&
                                eventDate.day == DateTime.now().day;
                        bool isCurrentUserEvent =
                            document['ID'] == currentUserId;
                        return isEventToday && isCurrentUserEvent;
                      }).toList();
                      // ignore: unnecessary_null_comparison
                      if (currentUserID != null) {
                        // Timer.periodic(Duration(hours: 6), (timer) {
                        //   NotificationService()
                        //       .checkAndScheduleNotifications(currentUserID);
                        // });
                        NotificationServiceAndroid().showNotification(
                            id: 0,
                            title: "BOA",
                            body: "Check Todays Event",
                            payLoad: "");
                        NotificationServiceAndroid().scheduleNotification(
                            id: 1,
                            title: "BOA Calendar",
                            body: "You have Events to Check",
                            scheduledDate: DateTime(10, 59, 0));
                      }
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 0), // Adjust the left padding as needed
                        child: todaysDocuments.isEmpty
                            ? Center(
                                child: Text(
                                  'OOPS!! No events found for today...',
                                  style: GoogleFonts.acme(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: todaysDocuments.map((document) {
                                  String id = document['EventTitle'];
                                  String message = document['EventDescription'];

                                  // Parse the date string to DateTime
                                  DateTime eventDate =
                                      DateTime.parse(document['Date']);
                                  String date = document['Date'];
                                  // Calculate days difference
                                  int daysDifference = eventDate
                                      .difference(DateTime.now())
                                      .inDays;

                                  // Determine color based on days difference
                                  Color color;
                                  if (daysDifference <= 15) {
                                    color =
                                        const Color.fromARGB(255, 233, 176, 64);
                                  } else {
                                    color =
                                        const Color.fromARGB(255, 98, 201, 102);
                                  }

                                  return CardBuilder(
                                    title: id,
                                    description: message,
                                    color: color,
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
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const MyCarouselSlider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 250, 10),
                child: Text(
                  "Upcoming Events",
                  style: GoogleFonts.acme(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                          "Oops, you have no Upcoming events",
                          style: GoogleFonts.acme(
                              fontSize: 20, fontWeight: FontWeight.bold),
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
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MyNavBar(
        index: 0,
      ),
    );
  }
}
