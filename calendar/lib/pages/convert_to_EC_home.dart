import 'package:calendar/components/my_button.dart';
import 'package:calendar/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:abushakir/abushakir.dart'; // Import the abushakir package
import '../components/my_text_field.dart';
import 'conver_to_GC_Home.dart';

class ConverterPageToEth extends StatefulWidget {
  final void Function()? ontap;
  final Function(int)? onIndexChanged;
  const ConverterPageToEth({super.key, this.onIndexChanged, this.ontap});

  @override
  State<ConverterPageToEth> createState() => _ConverterPageToEthState();
}

class _ConverterPageToEthState extends State<ConverterPageToEth> {
  final dateController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();
  int index = 1;
  Color unselectedColor = Colors.black;
  Color selectedColor = const Color.fromARGB(255, 233, 176, 64);

  String? convertedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 247, 247, 247),
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            icon: Icon(Icons.arrow_back_ios)),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ConverterPageHome()));
            },
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Icon(
                Icons.next_plan,
                size: 40,
                color: Color.fromARGB(255, 233, 176, 64),
              ),
            ),
          )
        ],
        title: const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
          child: Text(
            'Converting Dates to Ethiopian...',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  "Date",
                  style: GoogleFonts.acme(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: MyTextField(
                    hintText: "DD",
                    controllers: dateController,
                    obscureText: false),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  "Month",
                  style: GoogleFonts.acme(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: MyTextField(
                    hintText: "MM",
                    controllers: monthController,
                    obscureText: false),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  "Year",
                  style: GoogleFonts.acme(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: MyTextField(
                    hintText: "YYYY",
                    controllers: yearController,
                    obscureText: false),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  int date = int.parse(dateController.text);
                  int month = int.parse(monthController.text);
                  int year = int.parse(yearController.text);
                  // Perform the conversion
                  EtDatetime etDatetime = EtDatetime.fromMillisecondsSinceEpoch(
                    DateTime(year, month, date).millisecondsSinceEpoch,
                  );

                  // Add one day to the resulting Ethiopian date
                  etDatetime = etDatetime.add(Duration(days: 1));

                  setState(() {
                    convertedDate = etDatetime.toString();
                  });

                  dateController.clear();
                  monthController.clear();
                  yearController.clear();
                },
                child: const MyButton(text: "Convert to Ethiopian Date"),
              ),
              if (convertedDate != null)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Converted Ethiopian Date: $convertedDate',
                    style: GoogleFonts.acme(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
