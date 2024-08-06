import 'package:calendar/pages/converter_to_ethiopian_page.dart';
import 'package:calendar/pages/converter_to_gregorian_page.dart';
import 'package:flutter/material.dart';

class EthOrGregorian extends StatefulWidget {
  const EthOrGregorian({super.key});

  @override
  State<EthOrGregorian> createState() => _EthOrGregorianState();
}

class _EthOrGregorianState extends State<EthOrGregorian> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return ConverterPage(
        ontap: togglePages,
      );
    }
    return ConverterPageToEth(
      ontap: togglePages,
    );
  }
}
