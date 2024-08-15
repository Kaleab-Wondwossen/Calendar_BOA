import 'package:calendar/components/my_button.dart';
import 'package:calendar/components/my_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  late TextEditingController emailController;
  late FirebaseAuth auth;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    auth = FirebaseAuth.instance;
  }

  Future<void> passwordReset(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email for Password Reset Sent to $email")));
      emailController.clear();
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send reset email: $e")));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 247, 247, 247),
        title: Text(
          'Password Reset',
          style: GoogleFonts.acme(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                0, 0, 0, MediaQuery.of(context).size.width * 0.2),
            child: Image.asset("images/logo&name.png"),
          ),
          Text(
            "Input your valid, usable email!",
            style: GoogleFonts.acme(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.1,
                0,
                MediaQuery.of(context).size.width * 0.1,
                0),
            child: MyTextField(
              hintText: "Email",
              obscureText: false,
              controllers: emailController,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () async {
              await passwordReset(emailController.text);
              emailController.clear();
            },
            child: MyButton(text: "Send Link"),
          ),
        ],
      ),
    );
  }
}
