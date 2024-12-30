import 'package:calendar/components/my_button.dart';
import 'package:calendar/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/my_text_field.dart';
import 'convert_to_EC_home.dart';

class ConverterPageHome extends StatefulWidget {
  final void Function()? ontap;
  final Function(int)? onIndexChanged;
  const ConverterPageHome({super.key, this.onIndexChanged, this.ontap});

  @override
  State<ConverterPageHome> createState() => _ConverterPageHomeState();
}

class _ConverterPageHomeState extends State<ConverterPageHome> {
  final dateController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();
  int index = 1;
  Color unselectedColor = Colors.black;
  Color selectedColor = const Color.fromARGB(255, 233, 176, 64);

  String? convertedDate;
  DateTime ethiopianToGregorian(
      int ethiopianYear, int ethiopianMonth, int ethiopianDay) {
    int gregorianYear;
    if (ethiopianMonth >= 1 && ethiopianMonth <= 4) {
      gregorianYear = ethiopianYear + 8;
    } else {
      gregorianYear = ethiopianYear + 7;
    }

    DateTime ethiopianNewYear;
    if (DateTime(gregorianYear, 9, 11).isUtc) {
      ethiopianNewYear = DateTime(gregorianYear, 9, 11);
    } else {
      ethiopianNewYear = DateTime(gregorianYear, 9, 12);
    }

    // int daysInEthiopianMonths =
    //     [30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 5][ethiopianMonth - 1];
    int daysPassed = (ethiopianMonth - 1) * 30 + ethiopianDay;

    DateTime gregorianDate =
        ethiopianNewYear.add(Duration(days: daysPassed - 1));
    return gregorianDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 247, 247, 247),
        leading: IconButton(
            onPressed: () {
             Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          const HomePage(),
                                  transitionDuration:
                                      Duration.zero, // No transition duration
                                  reverseTransitionDuration: Duration
                                      .zero, // No reverse transition duration
                                ),
                              );
            icon: Icon(Icons.arrow_back_ios)),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          const ConverterPageToEth(),
                                  transitionDuration:
                                      Duration.zero, // No transition duration
                                  reverseTransitionDuration: Duration
                                      .zero, // No reverse transition duration
                                ),
                              ); 
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
            'Converting Dates to Gregorian...',
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
                  hintText: "26",
                  controllers: dateController,
                  obscureText: false,
                ),
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
                  hintText: "12",
                  controllers: monthController,
                  obscureText: false,
                ),
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
                  hintText: "1900",
                  controllers: yearController,
                  obscureText: false,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  int date = int.parse(dateController.text);
                  int month = int.parse(monthController.text);
                  int year = int.parse(yearController.text);

                  // Create an Ethiopian date
                  // EtDatetime etDatetime =
                  //     EtDatetime(year: year, month: month, day: date);

                  DateTime dateInGC = ethiopianToGregorian(year, month, date);
                  DateTime adjustedDateInGC =
                      dateInGC.subtract(Duration(days: 0));
                  setState(() {
                    convertedDate =
                        "${adjustedDateInGC.year}/${adjustedDateInGC.month}/${adjustedDateInGC.day}";
                  });

                  //Convert Ethiopian date to Gregorian date
                  //  DateTime gregorianDate = etDatetime.toGregorian();

                  // setState(() {
                  //   convertedDate =
                  //       '${gregorianDate.day}/${gregorianDate.month}/${gregorianDate.year}';
                  // });

                  dateController.clear();
                  monthController.clear();
                  yearController.clear();
                },
                child: const MyButton(text: "Convert to Gregorian Date"),
              ),
              if (convertedDate != null)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Converted Gregorian Date: $convertedDate',
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
