import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? ontap;
  final String text;
  const MyButton({super.key, this.ontap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: 400,
        height: 80,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 233, 176, 64),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(text, style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),),
        ),
      ),
    );
  }
}
