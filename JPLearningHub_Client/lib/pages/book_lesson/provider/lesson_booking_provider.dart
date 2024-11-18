import 'package:flutter/material.dart';
import 'package:jplearninghub/provider/timezone_state.dart';

class LessonBookingProvider extends ChangeNotifier {
  final DateTime minDate;
  final DateTime maxDate;

  LessonBookingProvider({required this.minDate, required this.maxDate});

  int? selectedDay;
  DateTime selectedMonth =
      DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime now = timezoneState.getLocalTime();

  int daysInMonth() {
    return DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;
  }

  DateTime firstDayOfMonth() {
    return DateTime(selectedMonth.year, selectedMonth.month, 1);
  }

  int startingWeekday() {
    return firstDayOfMonth().weekday;
  }

  void selectDay(int? day) {
    selectedDay = day;
    notifyListeners();
  }

  void nextMonth() {
    DateTime newMonth =
        DateTime(selectedMonth.year, selectedMonth.month + 1, 1);

    if (!canGoNextMonth()) {
      return;
    }

    selectedMonth = newMonth;
    notifyListeners();
  }

  bool canGoNextMonth() {
    DateTime newMonth =
        DateTime(selectedMonth.year, selectedMonth.month + 1, 1);
    return !(newMonth.isAfter(maxDate) &&
        !isDateTimeInMonth(newMonth, maxDate));
  }

  bool canGoPreviousMonth() {
    DateTime newMonth =
        DateTime(selectedMonth.year, selectedMonth.month - 1, 1);
    return !(newMonth.isBefore(minDate) &&
        !isDateTimeInMonth(newMonth, minDate));
  }

  void previousMonth() {
    DateTime newMonth =
        DateTime(selectedMonth.year, selectedMonth.month - 1, 1);

    if (!canGoPreviousMonth()) {
      return;
    }

    selectedMonth = newMonth;
    notifyListeners();
  }

  bool canGoNextDay() {
    DateTime newDay = DateTime(
        selectedMonth.year, selectedMonth.month, selectedDay! + 1, 0, 0, 0);
    return !(newDay.isAfter(maxDate));
  }

  bool canGoPreviousDay() {
    DateTime newDay = DateTime(
        selectedMonth.year, selectedMonth.month, selectedDay! - 1, 0, 0, 0);
    return !newDay.isBefore(minDate);
  }

  void nextDay() {
    if (!canGoNextDay()) {
      return;
    }
    selectedDay = selectedDay! + 1;
    notifyListeners();
  }

  void previousDay() {
    if (!canGoPreviousDay()) {
      return;
    }
    selectedDay = selectedDay! - 1;
    notifyListeners();
  }

  String getDatePretty() {
    return '${selectedMonth.year} ${getMonthName(selectedMonth.month)}';
  }

  String getDayDatePretty() {
    if (selectedDay == null) {
      return '';
    }
    String dayAppendix = 'th';
    if (selectedDay == 1) {
      dayAppendix = 'st';
    }

    if (selectedDay == 2) {
      dayAppendix = 'nd';
    }

    if (selectedDay == 3) {
      dayAppendix = 'rd';
    }
    //get the name of the day
    DateTime selectedDate =
        DateTime(selectedMonth.year, selectedMonth.month, selectedDay!);
    String selectedDayName = getDayName(selectedDate.weekday);

    return '$selectedDayName - ${selectedDate.day}$dayAppendix ${getMonthName(selectedDate.month)}';
  }

  DayType getDayType(int day) {
    DateTime relativeDay =
        DateTime(selectedMonth.year, selectedMonth.month, day);

    if (DateTime(now.year, now.month, now.day) == relativeDay) {
      return DayType.today;
    }

    if (relativeDay.isBefore(minDate) || relativeDay.isAfter(maxDate)) {
      return DayType.unavailable;
    }
    return DayType.available;
  }

  bool isDateTimeInMonth(DateTime dateTime, DateTime dateTime2) {
    return dateTime.year == dateTime2.year && dateTime.month == dateTime2.month;
  }

  String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
    }
    return '';
  }

  String getDayName(int day) {
    switch (day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
    }
    return '';
  }
}

enum DayType { today, available, unavailable }
