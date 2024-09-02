import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveHolidays(List<DateTime> holidays) async {
  final prefs = await SharedPreferences.getInstance();
  final holidayStrings = holidays.map((holiday) => holiday.toIso8601String()).toList();
  await prefs.setStringList('ethiopianHolidays', holidayStrings);
}

Future<List<DateTime>> loadHolidays() async {
  final prefs = await SharedPreferences.getInstance();
  final holidayStrings = prefs.getStringList('ethiopianHolidays') ?? [];
  return holidayStrings.map((holiday) => DateTime.parse(holiday)).toList();
}
