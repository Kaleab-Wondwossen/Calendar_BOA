import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';
import '../services/auth/auth_services.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? ontap;
  const RegisterPage({super.key, this.ontap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final confirmPassword = TextEditingController();

  Future<void> signUp() async {
    if (passwordcontroller.text != confirmPassword.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords dont Match")),
      );
      return;
    }
    final authServices = Provider.of<AuthServices>(context, listen: false);
    try {
      await authServices.signUpWithEmailAndPassword(
          emailcontroller.text, passwordcontroller.text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  //logo
                  Image.asset("images/logo&name.png"),
                  const SizedBox(
                    height: 30,
                  ),
                  //welcome text
                  const Text(
                    "Welcome To Register",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //sub welcome
                  const Text(
                    "let us know you",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  //input fields 1
                  MyTextField(
                      hintText: "Email",
                      controllers: emailcontroller,
                      obscureText: false,
                      leftIcon: Icons.email,
                      iconColor: Colors.grey),
                  const SizedBox(
                    height: 10,
                  ),
                  //input fields 2
                  MyTextField(
                      hintText: "Password",
                      controllers: passwordcontroller,
                      obscureText: true,
                      leftIcon: Icons.lock,
                      rightIcon: Icons.password,
                      iconColor: Colors.grey,),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                      hintText: "Confirm Password",
                      controllers: confirmPassword,
                      obscureText: true,
                      leftIcon: Icons.lock,
                      rightIcon: Icons.password,
                      iconColor: Colors.grey,),
                  //button
                  const SizedBox(
                    height: 25,
                  ),
                  //log in button
                  MyButton(
                    text: "Sign Up",
                    ontap: signUp,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  //dont have an account button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account ",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: widget.ontap,
                        child: const Text(
                          "Log In!",
                          style: TextStyle(
                              color: Color.fromARGB(255, 233, 176, 64),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
