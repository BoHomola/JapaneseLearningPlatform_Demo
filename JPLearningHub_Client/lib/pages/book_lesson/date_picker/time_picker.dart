import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jplearninghub/api/lesson_api.dart';
import 'package:jplearninghub/pages/book_lesson/provider/lesson_booking_provider.dart';
import 'package:jplearninghub/provider/booking_state.dart';
import 'package:jplearninghub/provider/timezone_state.dart';
import 'package:jplearninghub/widgets/double_button.dart';
import 'package:provider/provider.dart';

class TimePicker extends StatelessWidget {
  const TimePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LessonBookingProvider>(context);

    DateTime from = DateTime.utc(provider.selectedMonth.year,
        provider.selectedMonth.month, provider.selectedDay!);
    DateTime to = DateTime.utc(provider.selectedMonth.year,
        provider.selectedMonth.month, provider.selectedDay! + 1);

    int offset = timezoneState.getOffsetInMinutes();
    from = from.add(Duration(minutes: -offset));
    to = to.add(Duration(minutes: -offset));

    return Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildDayNavigator(context),
                const SizedBox(height: 40),
                DoubleButton(
                    leftButtonText: "30 minutes",
                    rightButtonText: "50 minutes",
                    onLeftButtonPressed: (bool _) =>
                        print("Left Button Pressed"),
                    onRightButtonPressed: (bool _) =>
                        print("Right Button Pressed")),
                const SizedBox(height: 40),
                const Divider(),
                const SizedBox(height: 40),
                FutureBuilder(
                  //TODO: Add 30/60mins length
                  future: getAvailableTimeSlots(from, to, 30),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 100,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 1.8),
                        itemCount: snapshot.data!.length, // 6 weeks * 7 days
                        itemBuilder: (context, index) {
                          var timeslot = snapshot.data![index];
                          return InkWell(
                            borderRadius: BorderRadius.circular(20),
                            splashColor: Colors.green[100],
                            onTap: () {
                              final bookingProvider =
                                  Provider.of<BookingProvider>(context,
                                      listen: false);
                              bookingProvider.addBooking(
                                Booking(
                                    dateTime: timeslot.from,
                                    length: LessonLength.short),
                              );
                              context.go('/booking');
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.green[100],
                              ),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    timezoneState
                                        .convertUtcToLocalTime(timeslot.from)
                                        // timeslot.from
                                        .toString()
                                        .substring(11, 16),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildDayNavigator(BuildContext context) {
    final provider = Provider.of<LessonBookingProvider>(context);
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            provider.selectDay(null);
          },
          child: Ink(
            width: 240,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_month),
                SizedBox(width: 20),
                Text("Select date",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 60),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: provider.canGoPreviousDay()
                  ? () {
                      provider.previousDay();
                    }
                  : null,
            ),
            Text(provider.getDayDatePretty(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: provider.canGoNextDay()
                  ? () {
                      provider.nextDay();
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}
