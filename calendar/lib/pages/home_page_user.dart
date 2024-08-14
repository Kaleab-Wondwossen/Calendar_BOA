import 'package:calendar/components/my_admin_events.dart';
import 'package:calendar/pages/foriegn_exchange.dart';
import 'package:calendar/pages/home_page.dart';
import 'package:calendar/pages/loan_calculator.dart';
import 'package:calendar/services/toggle/to_eth_or_gregorian.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/my_carousel_slider.dart';
import '../components/my_table_calendar.dart';
import '../services/auth/auth_gate.dart';
import 'weather_page.dart';

class HomePageUser extends StatefulWidget {
  final Function(int)? onIndexChanged;
  const HomePageUser({super.key, this.onIndexChanged});

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

Future<void> checkUser(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) {
      return StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomePage();
            } else {
              return AuthGate();
            }
          });
    }),
  );
}

class _HomePageUserState extends State<HomePageUser> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int index = 0;
  Color unselectedColor = Colors.black;
  Color selectedColor = const Color.fromARGB(255, 233, 176, 64);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          key: _scaffoldKey, // Assign the GlobalKey to the Scaffold
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 50,
            backgroundColor: const Color.fromARGB(255, 233, 176, 64),
            title: const Text(
              'C A L E N D A R',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 233, 176, 64),
                    ),
                    child: Text(
                      'More from Calendar',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: const Text('Loan Calculator'),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoanCalculator()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.currency_exchange),
                  title: const Text('Foreign Exchange Rate'),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForeignExchange()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cloud_circle),
                  title: const Text('Weather'),
                  onTap: () {
                    // Navigate to help page or perform action
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WeatherPage()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_back_ios),
                  title: const Text('Back'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * 0.2,
                  decoration:
                      BoxDecoration(color: Color.fromARGB(255, 233, 176, 64)),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.01, 0, 0, 0),
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
                                "images/name.png",
                                width: 150,
                                height: 60,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.16, 0, 0, 0),
                        child: GestureDetector(
                          onTap: () {
                            checkUser(context);
                          },
                          child: const Icon(Icons.login),
                        ),
                      ),
                    ],
                  ),
                ),
                const MyCalendar(
                  height: 80,
                ),
                const MyCarouselSlider(),
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
                
                const AdminEvents()
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: index,
            unselectedItemColor: unselectedColor,
            selectedItemColor: selectedColor,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Calendar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.change_circle),
                label: 'Converter',
              ),
            ],
            onTap: (index) {
              if (widget.onIndexChanged != null) {
                widget.onIndexChanged!(index);
              }
              if (index != 0) {
                switch (index) {
                  case 0:
                    if (index != 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePageUser()));
                    }
                    break;
                  case 1:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EthOrGregorian()));

                    break;
                }
              }
            },
          )),
    );
  }
}
