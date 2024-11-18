import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jplearninghub/api/lesson_api.dart';
import 'package:jplearninghub/models/lesson_model.dart';
import 'package:jplearninghub/provider/booking_state.dart';
import 'package:jplearninghub/provider/timezone_state.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class NewBookingScreen extends StatelessWidget {
  const NewBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Select a date', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 20),
        FutureBuilder<TimeslotsModel?>(
          future: getAvailableTimeSlots(
              DateTime.now(),
              DateTime.now()
                  .add(const Duration(days: 90))), // The method you created
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              DateTime now = DateTime.now();
              DateTime nowDate = DateTime(now.year, now.month, now.day);
              String timezone = timezoneState.userTimezoneString;
              return Expanded(
                child: SfCalendar(
                  view: CalendarView.week,
                  timeSlotViewSettings: const TimeSlotViewSettings(
                    timeInterval: Duration(minutes: 30),
                    timeFormat: 'HH:mm',
                  ),
                  specialRegions: getUnavailableTimeRegions(
                      snapshot.data!.unavailableTimeslots),
                  showDatePickerButton: true,
                  showCurrentTimeIndicator: true,
                  showNavigationArrow: true,
                  timeZone: timezone,
                  viewNavigationMode: ViewNavigationMode.snap,
                  maxDate: nowDate.add(const Duration(days: 90)),
                  minDate: now,
                  onTap: (calendarTapDetails) {
                    if (calendarTapDetails.date == null) {
                      return;
                    }
                    final bookingProvider =
                        Provider.of<BookingProvider>(context, listen: false);
                    bookingProvider.addBooking(
                      Booking(
                          dateTime: calendarTapDetails.date!,
                          length: LessonLength.short),
                    );
                    context.go('/booking');
                  },
                  headerStyle: const CalendarHeaderStyle(
                    textAlign: TextAlign.center,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              );
            } else {
              return const Text('No data available');
            }
          },
        ),
      ],
    );
  }

  getUnavailableTimeRegions(List<TimeSlotModel> unavailableTimeslots) {
    final List<TimeRegion> regions = <TimeRegion>[];
    for (var unavailableTimeslot in unavailableTimeslots) {
      regions.add(TimeRegion(
        startTime: unavailableTimeslot.from,
        endTime: unavailableTimeslot.to,
        enablePointerInteraction: false,
        color: Colors.grey.withOpacity(0.2),
        timeZone: 'UTC',
        text: '',
      ));
    }

    return regions;
  }
}
