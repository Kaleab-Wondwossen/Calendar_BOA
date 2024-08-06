import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriesCard extends StatefulWidget {
  final IconData icon;
  final String text;
  final Color backgroundColor;
  final Color iconColor;
  final String subText;

  const CategoriesCard({
    super.key,
    required this.icon,
    required this.text,
    this.backgroundColor = const Color.fromARGB(255, 244, 245, 227),
    this.iconColor = const Color.fromARGB(255, 233, 176, 64),
    required this.subText,
  });

  @override
  State<CategoriesCard> createState() => _CategoriesCardState();
}

class _CategoriesCardState extends State<CategoriesCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 150,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(widget.icon, size: 50, color: widget.iconColor),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            child: Text(
              widget.text,
              style: GoogleFonts.acme(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              widget.subText,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          )
        ],
      ),
    );
  }
}
