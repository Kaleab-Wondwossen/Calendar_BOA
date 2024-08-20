import 'dart:math';
import 'package:calendar/components/my_button.dart';
import 'package:calendar/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/my_text_field.dart';
import 'home_page_user.dart';

const List<String> list = <String>[
  'END - OF - PERIOD',
  'START - OF - PERIOD'
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
                  Text("Amount: ", style: GoogleFonts.acme(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                  ),),
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
                  Text("Month:          ", style: GoogleFonts.acme(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                  ),),
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
              padding: const EdgeInsets.fromLTRB(10, 0, 100, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Rate:               ", style: GoogleFonts.acme(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                  ),),
                  const SizedBox(width: 5),
                  Expanded(
                      child: MyTextField(
                          hintText: "Annual Interest Rate",
                          controllers: intrestRateController,
                          obscureText: false)),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 100, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Method:          ", style: GoogleFonts.acme(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                  ),),
                  const SizedBox(width: 3.5),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0,0,MediaQuery.of(context).size.width * 0.00000001,0),
                    child: DropdownButton(
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
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0,0,50,0),
              child: Row(
                children: [
                  Text("Monthly \nPayment:", style: GoogleFonts.acme(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Expanded(
                      child: MyTextField(
                       hintText: "${monthlyPayment?.toStringAsFixed(2) ?? '#######'}",
                       obscureText: false,
                      ),
                    )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0,0,50,0),
              child: Row(
                children: [
                  Text("Total \nInterest:  ", style: GoogleFonts.acme(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Expanded(
                      child: MyTextField(
                       hintText: "${totalInterest?.toStringAsFixed(2) ?? '#######'}",
                       obscureText: false,
                      ),
                    )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10,0,50,0),
              child: Row(
                children: [
                  Text("Total Principal \nand Interest:", style: GoogleFonts.acme(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Expanded(
                      child: MyTextField(
                       hintText: "${totalPrincipalInterest?.toStringAsFixed(2) ?? '#######'}",
                       obscureText: false,
                      ),
                    )
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(110, 20, 110, 20),
              child: GestureDetector(
                  onTap: () {
                    _calculateLoan();
                    //_showDialog(context);
                  },
                  child: const MyButton(text: "CALCULATE")),
            ),
          ],
        ),
      ),
    );
  }
}
