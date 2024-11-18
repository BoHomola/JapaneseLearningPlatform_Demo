// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jplearninghub/provider/booking_state.dart';
import 'package:provider/provider.dart';
// import 'package:jplearninghub/models/user_model.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({
    required this.booking,
    super.key,
  });

  // final LessonModel lesson;
  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('EEEE, MMMM d, y').format(booking.dateTime.toLocal());
    final formattedTime =
        DateFormat('h:mm a').format(booking.dateTime.toLocal());

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$formattedDate at $formattedTime',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Lesson Length: ${booking.length == LessonLength.short ? '30 minutes' : '50 minutes'}',
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                final bookingProvider =
                    Provider.of<BookingProvider>(context, listen: false);
                bookingProvider.removeBooking(booking);
              },
            ),
          ],
        ),
      ),
    );
  }
}
