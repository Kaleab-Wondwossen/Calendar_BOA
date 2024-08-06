import 'package:calendar/components/my_dashboard_tab.dart';
import 'package:calendar/components/my_hero_banner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'chat_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late DateTime today;
  late DateTime day;
  late DateTime month;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    day = DateTime(today.year, today.month, today.day);
    month = DateTime(today.year, today.month);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      body: SafeArea(
        child: Column(
          children: [
            const HeroBanner(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            DateFormat.MMMM().format(
                              month,
                            ), // Using MMM for abbreviated month name
                            style: GoogleFonts.acme(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            " ${DateFormat.d().format(day)}",
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
                          DateFormat.EEEE().format(today),
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
                      "Hello Admin",
                      style: GoogleFonts.acme(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Welcome to your calendar",
                      style: GoogleFonts.acme(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.person_rounded,
                    color: Color.fromARGB(255, 233, 176, 64),
                    size: 40,
                  ),
                ),
              ],
            ),
            const DashboardTab(),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 300, 10),
              child: Text(
                "Users List",
                style: GoogleFonts.acme(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildUserList(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshots) {
        if (snapshots.hasError) {
          return const Text("Error");
        }
        if (snapshots.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        final snapshotData = snapshots.data;
        if (snapshotData == null || snapshotData.docs.isEmpty) {
          return const Text("No users found");
        }

        final filteredDocs = snapshotData.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          if (data == null) return false;
          final email = data['email'] as String?;
          if (email == null) return false;
          return !email.endsWith('@admin.com');
        }).toList();

        return SizedBox(
          height: 400,
          width: 400,
          child: ListView(
            children: filteredDocs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>?;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    if (data == null) {
      return Container();
    }

    final email = data['email'] as String?;
    final uid = data['uid'] as String?;
    if (email == null || uid == null || _auth.currentUser?.email == email) {
      return Container();
    }

    return Column(
      children: [
        ListTile(
          leading: const CircleAvatar(
            radius: 25.0,
            backgroundColor: Color.fromARGB(255, 245, 222, 174),
          ),
          title: Text(
            email,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Poppins',
              letterSpacing: 1,
              wordSpacing: 1,
              height: 1.5,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ChatPage(
                    reciverUserEmail: email,
                    reciverUserID: uid,
                  );
                },
              ),
            );
          },
        ),
        const Divider(
          color: Color.fromARGB(255, 245, 222, 174),
          height: 30,
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }
}
