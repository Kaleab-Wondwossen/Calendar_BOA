import 'package:intl/intl.dart';

class Events {
  final String eventTitle;
  final String description;
  final String date;

  Events(this.eventTitle, this.description)
      : date = DateFormat('yyyy-MM-dd').format(DateTime.now());

  // Convert an Events object to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'eventTitle': eventTitle,
      'description': description,
      'date': date,
    };
  }
}
