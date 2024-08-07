import 'package:ethiopian_calendar/ethiopian_date_converter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/events.dart';

class MyCalendar extends StatefulWidget {
  final double? height;
  final CalendarFormat? format;
  const MyCalendar({super.key, this.height, this.format});

  @override
  State<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  bool isEthiopian = true; // State variable to toggle calendar type

  List<String> ethiopianDayNames = [
    'እሑድ', 
    'ሰኞ', 
    'ማክሰኞ', 
    'ረቡዕ', 
    'ሐሙስ', 
    'ዓርብ', 
    'ቅዳሜ', 
  ];
  List<String> ethiopianMonthNames = [
    'መስከረም',
    'ጥቅምት',
    'ህዳር',
    'ታህሳስ',
    'ጥር',
    'የካቲት',
    'መጋቢት',
    'ሚይዚያ',
    'ግንቦት',
    'ሰኔ',
    'ሐምሌ',
    'ነሐሴ',
    'ጳጉሜ',
  ];
  String getHeaderText(DateTime date) {
    if (isEthiopian) {
      final ethiopianDate = EthiopianDateConverter.convertToEthiopianDate(date);
      final ethiopianMonth = ethiopianDate.month;
      final ethiopianYear = ethiopianDate.year;
      return '${ethiopianMonthNames[ethiopianMonth - 1]} $ethiopianYear';
    } else {
      return DateFormat.yMMMM().format(date);
    }
  }

  Map<DateTime, List<Events>> evenets = {};
  late DateTime today;
  CalendarFormat _calendarFormat =
      CalendarFormat.month; // Define the initial format
  late final ValueNotifier<List<Events>> selectedEvent;
  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    selectedEvent = ValueNotifier(_getEventsForDay(today));
    selectedEvent.value = _getEventsForDay(today);
  }

  void onDaySelected(DateTime day, DateTime focusedDate) {
    setState(() {
      today = day;
    });
  }

  List<Events> _getEventsForDay(DateTime day) {
    return evenets[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isEthiopian = !isEthiopian;
              });
            },
            child: isEthiopian
                ? Text(
                    "G.C",
                    style: GoogleFonts.acme(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    "ዓ.ም",
                    style: GoogleFonts.acme(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        TableCalendar(
          locale: "en_US",
          rowHeight: 60,
          headerStyle: const HeaderStyle(
            formatButtonVisible: true,
            titleCentered: true,
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(color: Colors.black),
            weekendStyle: TextStyle(color: Colors.red),
            dowTextFormatter: (date, locale) {
              if (isEthiopian) {
                return ethiopianDayNames[(date.weekday % 7)];
              } else {
                return DateFormat.E(locale).format(date);
              }
            },
          ),
          calendarStyle: const CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Color.fromARGB(255, 245, 222, 174),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Color.fromARGB(255, 233, 176, 64),
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            selectedTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            markerDecoration: BoxDecoration(
              color: Color.fromARGB(255, 233, 176, 64),
              shape: BoxShape.circle,
            ),
            markerSize: 10.0,
          ),
          eventLoader: _getEventsForDay,
          selectedDayPredicate: (day) => isSameDay(day, today),
          onDaySelected: onDaySelected,
          availableGestures: AvailableGestures.all,
          focusedDay: today,
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 10, 16),
          calendarFormat:
              widget.format ?? _calendarFormat, // Set the initial format
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat =
                  format; // Update the format when the button is pressed
            });
          },
          calendarBuilders: CalendarBuilders(
            headerTitleBuilder: (context, date) {
              return Container(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    getHeaderText(date),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
            defaultBuilder: (context, date, _) {
              String displayDate;
              if (isEthiopian) {
                final etDate =
                    EthiopianDateConverter.convertToEthiopianDate(date);
                displayDate = '${etDate.day}';
              } else {
                displayDate = '${date.day}';
              }
              return Center(
                child: Text(
                  displayDate,
                  style: GoogleFonts.acme(color: Colors.black),
                ),
              );
            },
            selectedBuilder: (context, date, _) {
              String displayDate;
              if (isEthiopian) {
                final etDate =
                    EthiopianDateConverter.convertToEthiopianDate(date);
                displayDate = '${etDate.day}';
              } else {
                displayDate = '${date.day}';
              }
              return Container(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 233, 176, 64),
                  shape: BoxShape.circle,
                ),
                width: 50,
                height: 50,
                child: Text(
                  displayDate,
                  style: GoogleFonts.acme(color: Colors.black),
                ),
              );
            },
            todayBuilder: (context, date, _) {
              String displayDate;
              if (isEthiopian) {
                final etDate =
                    EthiopianDateConverter.convertToEthiopianDate(date);
                displayDate = '${etDate.day}';
              } else {
                displayDate = '${date.day}';
              }
              return Container(
                padding: EdgeInsets.fromLTRB(24, 18, 0, 0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 245, 222, 174),
                  shape: BoxShape.circle,
                ),
                width: 50,
                height: 50,
                child: Text(
                  displayDate,
                  style: GoogleFonts.acme(color: Colors.black),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isEthiopian)
              Text(
                DateFormat('yyyy-MM-dd').format(
                  EthiopianDateConverter.convertToEthiopianDate(today),
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
              )
            else
              Text(
                DateFormat('yyyy-MM-dd').format(today),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
          ],
        )
      ],
    );
  }
}
