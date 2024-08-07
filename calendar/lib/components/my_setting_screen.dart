import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/contacts.dart';
import '../pages/profile_page.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late String username;
  late String email;
  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static List<ContactsModel> getContacts = [
    ContactsModel(
        name: 'BOA Operator', number: '8397', image: 'images/App.png'),
  ];
  List<ContactsModel> displayList = List.from(getContacts);
  @override
  void initState() {
    super.initState();
    email = _firebaseAuth.currentUser!.email!;
    int endIndex = email.indexOf(RegExp(r'[.@]'));
    username = (endIndex == -1) ? email : email.substring(0, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Profile()));
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: const Text(
          "Settings",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            //Account
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Account",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
            ),
            GestureDetector(
              onTap: () {
                // Navigator.pushReplacement(context, route)
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200]),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 233, 176, 64),
                    // backgroundImage: NetworkImage('url'),
                  ),
                  title: Text('${username}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(email),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
            //Line Break
            const SizedBox(
              height: 16,
            ),
            const Divider(
              color: Colors.black45,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Setting',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 5,
            ),
            //Help Center
            GestureDetector(
              onTap: () {
                // Navigator.pushReplacement(context, route)
              },
              child: GestureDetector(
                onTap: () {
                  () async {
                    if (displayList.isNotEmpty &&
                        displayList[0].number != null) {
                      final Uri url = Uri(
                          scheme: 'tel',
                          // path: displayList[0].number!,
                          path: '8397');
                      try {
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          print("Can't launch url: $url");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Unable to launch dialer.')),
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
                        SnackBar(content: Text('No contact number available.')),
                      );
                    }
                  };
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200]),
                  child: const ListTile(
                    leading: Icon(
                      Icons.help_center,
                      size: 40,
                    ),
                    title: Text('Help Center',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            //About us
            GestureDetector(
              onTap: () {
                // Navigator.pushReplacement(context, route)
              },
              child: GestureDetector(
                onTap: () {
                  _launchURL('https://www.bankofabyssinia.com/');
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200]),
                  child: const ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      size: 40,
                    ),
                    title: Text("About us",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
