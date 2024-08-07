import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/profile_page.dart';
import 'my_button.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final picker = ImagePicker();
  File? image;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      _emailController.text = user.email ?? '';
      // Add code to fetch the user's display name if needed
    }
  }

  Future<void> _updateUserDetails() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        if (_emailController.text.isNotEmpty) {
          await user.updateEmail(_emailController.text);
        }
        if (_passwordController.text.isNotEmpty) {
          await user.updatePassword(_passwordController.text);
        }
        // Optionally update display name or other user profile fields
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Profile(),
              ),
            );
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.acme(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // _picker();
              },
              child: const CircleAvatar(
                backgroundColor: Color.fromARGB(255, 233, 176, 64),
                radius: 60,
                child: Icon(Icons.person),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  prefixIcon: const Icon(
                    Icons.mail,
                    size: 30,
                  ),
                  label: const Text("Email")),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              maxLength: 8,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              controller: _passwordController,
              decoration: InputDecoration(
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                enabledBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                prefixIcon: const Icon(
                  Icons.password,
                  size: 30,
                ),
                label: const Text("Password"),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: _updateUserDetails,
              child: MyButton(
                text: "Save Changes"
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImagePicker {
  // Add functionality for image picking if needed
}