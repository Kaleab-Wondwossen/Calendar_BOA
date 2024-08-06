import 'dart:io';
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final picker = ImagePicker();
  File? image;

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
                  ));
            },
            child: const Icon(Icons.arrow_back)),
            title: Text("Edit Profile", style: GoogleFonts.acme(
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),),
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
              controller: _nameController,
              decoration: InputDecoration(
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                enabledBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                prefixIcon: const Icon(
                  Icons.person,
                  size: 30,
                ),
                label: const Text("Name"),
              ),
            ),
            const SizedBox(
              height: 20,
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
            const MyButton(text: "Save Changes")
          ],
        ),
      ),
    );
  }
}

class ImagePicker {
}