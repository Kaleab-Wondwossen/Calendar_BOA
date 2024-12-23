import 'package:calendar/components/my_admin_events.dart';
import 'package:calendar/components/my_event_list.dart';
import 'package:calendar/components/my_category_card.dart';
import 'package:calendar/components/my_nav_bar.dart';
import 'package:calendar/components/my_passed_events.dart';
import 'package:calendar/components/my_table_calendar.dart';
import 'package:calendar/pages/birthday_page.dart';
import 'package:calendar/pages/match_page.dart';
import 'package:calendar/pages/meeting_page.dart';
import 'package:calendar/pages/people_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const MyCalendar(
              format: CalendarFormat.week,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 290, 0),
              child: Text(
                "Categories",
                style: GoogleFonts.acme(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          const BirthdayPage(),
                                  transitionDuration:
                                      Duration.zero, // No transition duration
                                  reverseTransitionDuration: Duration
                                      .zero, // No reverse transition duration
                                ),
                              );
                      },
                      child: const CategoriesCard(
                        icon: Icons.cake,
                        text: "Celebrations",
                        subText: "Where u can find Celebratrions in one tap",
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          const MeetingPage(),
                                  transitionDuration:
                                      Duration.zero, // No transition duration
                                  reverseTransitionDuration: Duration
                                      .zero, // No reverse transition duration
                                ),
                              );
                      },
                      child: const CategoriesCard(
                        icon: Icons.meeting_room,
                        text: "Meeting",
                        backgroundColor: Color.fromARGB(157, 156, 124, 124),
                        iconColor: Color.fromRGBO(146, 47, 47, 0.963),
                        subText: "You dont want to miss any of your events!!",
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                         Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          const MatchPage(),
                                  transitionDuration:
                                      Duration.zero, // No transition duration
                                  reverseTransitionDuration: Duration
                                      .zero, // No reverse transition duration
                                ),
                              );
                      },
                      child: const CategoriesCard(
                        icon: Icons.sports_soccer,
                        text: "Activites",
                        backgroundColor: Color.fromARGB(157, 164, 163, 207),
                        iconColor: Color.fromARGB(157, 85, 93, 248),
                        subText: "Matches and Fixitures and many more",
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          const PeoplePage(),
                                  transitionDuration:
                                      Duration.zero, // No transition duration
                                  reverseTransitionDuration: Duration
                                      .zero, // No reverse transition duration
                                ),
                              );
                      },
                      child: const CategoriesCard(
                        icon: Icons.person,
                        text: "People",
                        backgroundColor: Color.fromARGB(157, 170, 208, 147),
                        iconColor: Color.fromARGB(255, 107, 255, 74),
                        subText: "Find, meet and interact with people",
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 280, 0),
              child: Text(
                "Your Events",
                style: GoogleFonts.acme(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const EventList(),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 260, 10),
              child: Text(
                "Global Events",
                style: GoogleFonts.acme(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const AdminEvents(),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 260, 10),
              child: Text(
                "Passed Events",
                style: GoogleFonts.acme(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const MyPassedEvents()
          ],
        ),
      )),
      bottomNavigationBar: const MyNavBar(index: 1),
    );
  }
}
