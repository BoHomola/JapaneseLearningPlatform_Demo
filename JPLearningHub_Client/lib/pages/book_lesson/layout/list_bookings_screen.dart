import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jplearninghub/api/lesson_api.dart';
import 'package:jplearninghub/models/lesson_model.dart';
import 'package:jplearninghub/pages/book_lesson/booking_card.dart';
import 'package:jplearninghub/provider/booking_state.dart';
import 'package:jplearninghub/provider/lesson_state.dart';
import 'package:jplearninghub/provider/teacher_state.dart';
import 'package:jplearninghub/utils/logger.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ListBookingsScreen extends StatelessWidget {
  const ListBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    return MaxWidthBox(
      maxWidth: 1200,
      child: ResponsiveScaledBox(
        width: ResponsiveValue<double>(context, conditionalValues: [
          const Condition.smallerThan(name: TABLET, value: 450),
          const Condition.between(start: 850, end: 1100, value: 800),
          const Condition.largerThan(name: TABLET, value: 1000),
          // There are no conditions for width over 1200
          // because the `maxWidth` is set to 1200 via the MaxWidthBox.
        ]).value,
        child: Column(children: [
          Text('Book a lesson',
              style: Theme.of(context).textTheme.headlineLarge),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final booking = bookingProvider.bookings[index];
                      return BookingCard(booking: booking);
                    },
                    childCount: bookingProvider.bookings.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50,
                    width: 100,
                    child: ElevatedButton(
                      child: const Text('+ Add New Booking'),
                      onPressed: () => context.go('/booking/new'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                child: const Text("Proceed to Book"),
                onPressed: () async {
                  processBooking(context);
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> processBooking(BuildContext context) async {
    final bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);
    List<BookingRequestModel> bookingRequests = [];
    final teacher =
        Provider.of<TeachersState>(context, listen: false).teachers.firstOrNull;
    if (teacher == null) {
      return;
    }

    if (bookingProvider.bookings.isEmpty) {
      return;
    }

    for (int i = 0; i < bookingProvider.bookings.length; i++) {
      final booking = bookingProvider.bookings[i];
      bookingRequests.add(BookingRequestModel(
          bookingIndex: i,
          startDate: booking.dateTime.toUtc(),
          lessonLength: booking.length,
          teacherId: teacher.user.userId,
          lessonMessage: "test message"));
    }
    var result = await sendBookingRequest(bookingRequests);
    if (result == null) {
      logger.e('Failed to send booking request');
      return;
    }

    if (result.isEmpty) {
      logger.i('Booking request sent successfully');
      lessonState.loadLessons();
      bookingProvider.clearBookings();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking has been successful')),
        );
        context.go('/overview');
      }
      return;
    }
    logger.i('Some of the bookings were rejected!');
    for (var bookingIndex in result) {
      logger.i('Booking $bookingIndex rejected');
    }
  }
}
