import 'dart:math';
import 'package:calendar/components/my_button.dart';
import 'package:calendar/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/my_text_field.dart';
import 'home_page_user.dart';

const List<String> list = <String>[
  'E N D - OF - P E R I O D',
  'S T A R T - OF - P E R I O D'
];

class LoanCalculator extends StatefulWidget {
  const LoanCalculator({super.key});

  @override
  State<LoanCalculator> createState() => _LoanCalculatorState();
}

class _LoanCalculatorState extends State<LoanCalculator> {
  final loanController = TextEditingController();
  final monthController = TextEditingController();
  final intrestRateController = TextEditingController();
  final priceController = TextEditingController();

  double? monthlyPayment;
  double? totalInterest;
  double? totalPrincipalInterest;
  double? totalPayment;

  void _calculateLoan() {
    double p = double.parse(loanController.text);
    double r = double.parse(intrestRateController.text) / 100 / 12;
    double n = double.parse(monthController.text);

    monthlyPayment = p * r * pow(1 + r, n) / (pow(1 + r, n) - 1);
    totalPayment = monthlyPayment! * n;
    totalInterest = (totalPayment!) - p;
    totalPrincipalInterest = monthlyPayment! * n;

    setState(() {});
  }

  // void _showDialog(BuildContext context) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return SizedBox(
  //           width: 200,
  //           child: Column(
  //             children: [
  //               Text(
  //                   "Total Payment: ${totalPrincipalInterest?.toStringAsFixed(2) ?? ''}"),
  //               const SizedBox(
  //                 height: 20,
  //               ),
  //               Text(
  //                   "Total Interest: ${totalInterest?.toStringAsFixed(2) ?? ''}"),
  //               const SizedBox(
  //                 height: 20,
  //               ),
  //               Text(
  //                   "Monthly Payment: ${monthlyPayment?.toStringAsFixed(2) ?? ''}"),
  //               const SizedBox(
  //                 height: 20,
  //               )
  //             ],
  //           ),
  //         );
  //       });
  // }

  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 247, 247, 247),
        leading: IconButton(
            onPressed: () async {
              User? user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePageUser()),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              }
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text(
          "Loan Calculator",
          style: GoogleFonts.acme(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 100, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Amount: "),
                  const SizedBox(width: 20),
                  Expanded(
                    child: MyTextField(
                      hintText: "Loan Amount",
                      controllers: loanController,
                      obscureText: false,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 100, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Month:        "),
                  const SizedBox(width: 5),
                  Expanded(
                    child: MyTextField(
                      hintText: "Number of Months",
                      controllers: monthController,
                      obscureText: false,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Rate % ",
                    style: GoogleFonts.acme(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 233, 176, 64)
                          .withOpacity(1.0),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Method",
                    style: GoogleFonts.acme(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 233, 176, 64)
                          .withOpacity(1.0),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: MyTextField(
                          hintText: "Annual Interest Rate",
                          controllers: intrestRateController,
                          obscureText: false)),
                  const SizedBox(
                    width: 8,
                  ),
                  DropdownButton(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
                "Monthly Payment:                      ${monthlyPayment?.toStringAsFixed(2) ?? '..................'}",
                style: GoogleFonts.acme(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                )),
            const SizedBox(
              height: 10,
            ),
            Text(
                "Total Interest:                                 ${totalInterest?.toStringAsFixed(2) ?? '..................'}",
                style: GoogleFonts.acme(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                )),
            const SizedBox(
              height: 10,
            ),
            Text(
                "Total Principal and Interest: ${totalPrincipalInterest?.toStringAsFixed(2) ?? '..................'}",
                style: GoogleFonts.acme(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                )),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(100, 20, 100, 20),
              child: GestureDetector(
                  onTap: () {
                    _calculateLoan();
                    //_showDialog(context);
                  },
                  child: const MyButton(text: "C A L C U L A T E")),
            ),
          ],
        ),
      ),
    );
  }
}
