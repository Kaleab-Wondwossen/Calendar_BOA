import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controllers;
  final String hintText;
  final bool obscureText;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final Color? iconColor;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.controllers,
    required this.obscureText,
    this.leftIcon,
    this.rightIcon, 
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: TextField(
        controller: controllers,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 240, 235, 235),
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 240, 235, 235),
            ),
          ),
          fillColor: const Color.fromARGB(255, 251, 253, 255),
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          prefixIcon: leftIcon != null ? Icon(leftIcon, color: iconColor,) : null,
          suffixIcon: rightIcon != null ? Icon(rightIcon, color: iconColor,) : null,
        ),
      ),
    );
  }
}