import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/home_page_user.dart';
import '../pages/search_page.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key});
  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePageUser()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Image.asset(
                "images/logo&name.png",
                width: 180,
                height: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(120, 0, 0, 0),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchPage()));
                  },
                  icon: const Icon(
                    Icons.search,
                    size: 30,
                  )),
            ),
            IconButton(
                onPressed: () {
                  signOut(context);
                },
                icon: const Icon(
                  Icons.logout,
                  size: 30,
                )),
          ],
        ),
      ],
    );
  }
}
