import 'package:flutter/material.dart';

import '../pages/conver_to_GC_Home.dart';
import '../pages/foriegn_exchange.dart';
import '../pages/loan_calculator.dart';
import '../pages/weather_page.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 233, 176, 64),
            ),
            child: Text(
              'More from Calendar',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('Loan Calculator'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoanCalculator()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: const Text('Foreign Exchange Rate'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForeignExchange()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.cloud_circle),
            title: const Text('Weather'),
            onTap: () {
              // Navigate to help page or perform action
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const WeatherPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.change_circle),
            title: const Text('Converters'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConverterPageHome()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.arrow_back_ios),
            title: const Text('Back'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
