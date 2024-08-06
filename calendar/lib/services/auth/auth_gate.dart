import 'package:calendar/pages/admin_home_page.dart';
import 'package:calendar/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_or_register.dart';

class AuthGate extends StatelessWidget {
  AuthGate({super.key});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> _getUserRole(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data()['role'] as String?;
      }
    } catch (e) {
      print('Error fetching user role:$e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if(snapshot.hasData && snapshot.data != null) {
            final String currentUserEmail = snapshot.data!.email!;
            return FutureBuilder<String?>(
              future: _getUserRole(currentUserEmail),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (roleSnapshot.hasData) {
                  final role = roleSnapshot.data;
                  if (role == 'admin') {
                    return const AdminHomePage();
                  } else {
                    return const HomePage();
                  }
                } else {
                  print(currentUserEmail);
                  return const Center(
                    child: Text('Error: Unable to fetch user role'),
                  );
                }
              },
            );
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
