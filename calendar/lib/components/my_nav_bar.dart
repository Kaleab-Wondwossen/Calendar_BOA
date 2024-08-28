import 'package:calendar/components/new_table_calendar.dart';
import 'package:calendar/pages/ai_page.dart';
import 'package:calendar/pages/inbox_page.dart';
import 'package:calendar/pages/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../pages/events_page.dart';

class MyNavBar extends StatefulWidget {
  final int index;
  final Function(int)? onIndexChanged;

  const MyNavBar({super.key, required this.index, this.onIndexChanged});

  @override
  State<MyNavBar> createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {
  String getChatRoomId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort();
    return ids.join('_');
  }

  @override
  Widget build(BuildContext context) {
    Color unselectedColor = Colors.black;
    Color selectedColor = const Color.fromARGB(255, 233, 176, 64);

    return BottomNavigationBar(
      currentIndex: widget.index,
      unselectedItemColor: unselectedColor,
      selectedItemColor: selectedColor,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.all_inbox),
          label: 'Inbox',
          activeIcon: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chat_rooms')
                .doc("qOKnO7ffQYPnwA7N98M4yURQbH33_x62G1GJfcwh5kioho16T3kIXV353")
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              var chatRoomData = snapshot.data!.data() as Map<String, dynamic>;
              bool hasNewMessages = chatRoomData['hasNewMessage'] ?? false;

              return Stack(
                children: [
                  const Icon(Icons.all_inbox),
                  if (hasNewMessages)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.red,
                        child: const Text(
                          'New Messages',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.computer),
          label: 'AI',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_2_rounded),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        if (widget.index != index) {
          if (widget.onIndexChanged != null) {
            widget.onIndexChanged!(index);
          }
          switch (index) {
            case 0:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const HomePage()));
              break;
            case 1:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const Events()));
              break;
            case 2:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const ChatPage()));
              break;
            case 3:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const ChatScreen()));
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => const NewTableCalendar()));
              break;
            case 4:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const Profile()));
              break;
          }
        }
      },
    );
  }
}