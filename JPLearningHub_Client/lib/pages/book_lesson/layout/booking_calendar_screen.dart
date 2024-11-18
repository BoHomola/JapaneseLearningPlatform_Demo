import 'package:flutter/material.dart';
import 'package:jplearninghub/pages/book_lesson/date_picker/date_picker.dart';
import 'package:jplearninghub/pages/book_lesson/date_picker/time_picker.dart';
import 'package:jplearninghub/pages/book_lesson/provider/lesson_booking_provider.dart';
import 'package:jplearninghub/provider/timezone_state.dart';
import 'package:provider/provider.dart';

class BookingCalendarScreen extends StatelessWidget {
  const BookingCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime localNow = timezoneState.getLocalTime();
    DateTime from = DateTime(localNow.year, localNow.month, localNow.day);
    DateTime to = DateTime(localNow.year, localNow.month, localNow.day + 90);
    return ChangeNotifierProvider(
        create: (context) => LessonBookingProvider(minDate: from, maxDate: to),
        child: Consumer<LessonBookingProvider>(
            builder: (context, provider, child) {
          if (provider.selectedDay == null) {
            return const DatePicker();
          } else {
            return const TimePicker();
          }
        }));
  }
}
