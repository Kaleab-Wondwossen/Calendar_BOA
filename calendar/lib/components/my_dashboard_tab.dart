// import 'package:calendar/pages/add_event_page.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../pages/search_page.dart';

// class DashboardTab extends StatelessWidget {
//   const DashboardTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//               padding: const EdgeInsets.all(20),
//               child: Stack(
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height * 0.2,
//                     decoration: BoxDecoration(
//                       color: const Color.fromARGB(255, 233, 176, 64),
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.3),
//                           spreadRadius: 10,
//                           blurRadius: 20,
//                           offset:
//                               const Offset(0, 3), // changes position of shadow
//                         ),
//                       ],
//                     ),
//                   ),
//                   Positioned(
//                     top: 10,
//                     left: 20,
//                     child: Text(
//                       'Dashboard',
//                       style: GoogleFonts.acme(
//                         color: Colors.black,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Column(
//                               children: [
//                                 IconButton(
//                                   onPressed: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const AdminAddEvent()));
//                                   },
//                                   icon: const Icon(Icons.add, size: 30,),
//                                   color: Colors.black,
//                                 ),
//                                 const SizedBox(height: 5),
//                                 const Text(
//                                   'Add',
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Column(
//                               children: [
//                                 IconButton(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const SearchPage()));
//                                     },
//                                     icon: const Icon(Icons.search, size: 30,),
//                                     color: Colors.black),
//                                 const SizedBox(height: 5),
//                                 const Text(
//                                   'Search',
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Column(
//                               children: [
//                                 IconButton(
//                                     onPressed: () {
//                                       // Navigator.push(
//                                       //   context,
//                                       //   MaterialPageRoute(
//                                       //       builder: (context) =>
//                                       //           const Pension()));
//                                     },
//                                     icon: const Icon(Icons.swap_horizontal_circle, size: 30,),
//                                     color: Colors.black),
//                                 const SizedBox(height: 5),
//                                 const Text(
//                                   'Switch',
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//   }
// }
import 'package:calendar/pages/add_event_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/search_page.dart';
import '../pages/home_page.dart'; // Import the HomePage
import '../pages/admin_home_page.dart'; // Import the AdminHomePage

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  bool isHomePage = false; // State variable to track the current page

  void toggleSwitch() {
    setState(() {
      isHomePage = !isHomePage; // Toggle the state variable
      navigateToPage(); // Call the method to navigate
    });
  }

  void navigateToPage() {
    if (isHomePage) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminHomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 233, 176, 64),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 10,
                  blurRadius: 20,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            left: 20,
            child: Text(
              'Dashboard',
              style: GoogleFonts.acme(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AdminAddEvent(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.add,
                            size: 30,
                          ),
                          color: Colors.black,
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SearchPage(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.search,
                            size: 30,
                          ),
                          color: Colors.black,
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Search',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: toggleSwitch, // Call the toggleSwitch method
                          icon: const Icon(
                            Icons.swap_horizontal_circle,
                            size: 30,
                          ),
                          color: Colors.black,
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Switch',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Current Page: ${isHomePage ? "Home" : "Admin"}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
