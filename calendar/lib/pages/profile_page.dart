import 'package:calendar/pages/home_page_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/my_nav_bar.dart';
import '../components/my_profile_screen.dart';
import '../components/my_setting_screen.dart';
import '../model/contacts.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String username;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static List<ContactsModel> getContacts = [
    ContactsModel(
        name: 'BOA Operator', number: '8397', image: 'images/App.png'),
  ];
  List<ContactsModel> displayList = List.from(getContacts);
  @override
  void initState() {
    super.initState();
    String email = _firebaseAuth.currentUser!.email!;
    int endIndex = email.indexOf(RegExp(r'[.@]'));
    username = (endIndex == -1) ? email : email.substring(0, endIndex);
  }
  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePageUser()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Color.fromARGB(255, 233, 176, 64),
                // backgroundImage: NetworkImage('url'),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              username,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Text(
              _firebaseAuth.currentUser!.email!,
              style: const TextStyle(color: Colors.black45),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Profilescreen(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200]),
                      child: const ListTile(
                        leading: Icon(
                          Icons.person,
                          size: 40,
                        ),
                        title: Text('Profile',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Setting
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingScreen(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200]),
                      child: const ListTile(
                        leading: Icon(
                          Icons.settings,
                          size: 40,
                        ),
                        title: Text('Setting',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Contact
                  GestureDetector(
                    onTap: () {
                      _launchURL('https://www.bankofabyssinia.com/');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200]),
                      child: const ListTile(
                        leading: Icon(
                          Icons.mail,
                          size: 40,
                        ),
                        title: Text('Contact',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Help
                  GestureDetector(
                    onTap: () async {
                      if (displayList.isNotEmpty &&
                          displayList[0].number != null) {
                        final Uri url = Uri(
                          scheme: 'tel',
                          // path: displayList[0].number!,
                          path: '8397'
                        );
                        try {
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            print("Can't launch url: $url");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Unable to launch dialer.')),
                            );
                          }
                        } catch (e) {
                          print("Error launching url: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'An error occurred while trying to dial.')),
                          );
                        }
                      } else {
                        print("No contact number available");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('No contact number available.')),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200]),
                      child: const ListTile(
                        leading: Icon(
                          Icons.help,
                          size: 40,
                        ),
                        title: Text('Help',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  GestureDetector(
                    onTap: () {
                      signOut(context);
                    },
                    child: Text(
                      "Sign out",
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 20,
                        color: Colors.redAccent[700],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MyNavBar(
        index: 4,
      ),
    );
  }
}
