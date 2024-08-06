import 'package:calendar/pages/home_page.dart';
import 'package:calendar/pages/home_page_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_currency_rate/live_currency_rate.dart';

class ForeignExchange extends StatelessWidget {
  const ForeignExchange({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String rates = "Click to get Rates";
  bool isLoading = false;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Currency"),
        leading: IconButton(
            onPressed: () async {
              User? user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                // No user is signed in
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePageUser()),
                );
              } else {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              }
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: InkWell(
        onTap: () async {
          setState(() {
            isLoading = true;
            errorMessage = "";
          });
          try {
            print("Fetching currency rate...");
            CurrencyRate rate =
                await LiveCurrencyRate.convertCurrency("USD", "ETB", 1);

            print("Rate fetched: ${rate.result}");
            setState(() {
              rates = "1 USD  =  ${rate.result} ETB";
              isLoading = false;
            });
          } catch (error) {
            print("Error: $error");
            setState(() {
              errorMessage = "Failed hitting API: ${error.toString()}";
              isLoading = false;
            });
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: size.width,
                child: const Text(
                  "USD to ETB",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22),
                )),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      const Text(
                        "Real-Time Current Rate",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        rates,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                      ),
                      if (errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
