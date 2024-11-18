import 'package:flutter/foundation.dart';
import 'package:jplearninghub/provider/auth_state.dart';
import 'package:json_annotation/json_annotation.dart';

enum LessonLength {
  @JsonValue(0)
  short,
  @JsonValue(1)
 long
}

class Booking {
  final DateTime dateTime;
  final LessonLength length;

  Booking({required this.dateTime, required this.length});
}

class BookingProvider extends ChangeNotifier {
  final List<Booking> _bookings = [];

  List<Booking> get bookings => _bookings;

  BookingProvider() {
    authState.logoutStream.stream.listen((event) {
      clearBookings();
    });
  }

  void removeBooking(Booking booking) {
    _bookings.remove(booking);
    notifyListeners();
  }

  void clearBookings() {
    _bookings.clear();
    notifyListeners();
  }

  void addBooking(Booking booking) {
    _bookings.add(booking);
    notifyListeners();
  }
}
