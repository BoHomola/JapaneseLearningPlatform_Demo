import 'dart:convert';

import 'package:jplearninghub/api/api_facade.dart';
import 'package:jplearninghub/models/lesson_model.dart';
import 'package:jplearninghub/utils/logger.dart';

Future<List<LessonModel>> getLessons() async {
  var response =
      await apiFacade.sendRequest(RequestMethod.get, "lessons", true);
  if (response.statusCode == 200) {
    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
    return parsed
        .map<LessonModel>((json) => LessonModel.fromJson(json))
        .toList();
  } else {
    logger.e('Failed to load lessons : ${response.statusCode}');
  }

  return [];
}

Future<List<TimeSlotModel>> getAvailableTimeSlots(
    DateTime from, DateTime to, int strideInMinutes) async {
  var response = await apiFacade.sendRequest(
      RequestMethod.get, "timeslots", true, queryParameters: {
    'startDate': from.toIso8601String(),
    'endDate': to.toIso8601String()
  });
  if (response.statusCode == 200) {
    TimeslotsModel occupiedSlots =
        TimeslotsModel.fromJson(jsonDecode(response.body));

    List<TimeSlotModel> availableSlots = [];
    DateTime currentTime = from;

    for (var unavailableSlot in occupiedSlots.unavailableTimeslots) {
      while (currentTime.isBefore(unavailableSlot.from)) {
        DateTime slotEnd = currentTime.add(Duration(minutes: strideInMinutes));
        if (slotEnd.isAfter(unavailableSlot.from)) {
          slotEnd = unavailableSlot.from;
        }
        if (slotEnd.isAfter(to)) {
          slotEnd = to;
        }
        if (slotEnd.isAfter(currentTime)) {
          availableSlots.add(TimeSlotModel(from: currentTime, to: slotEnd));
        }
        currentTime = slotEnd;
        if (currentTime.isAtSameMomentAs(to) || currentTime.isAfter(to)) {
          break;
        }
      }
      currentTime = unavailableSlot.to;
    }

    // Handle any remaining time after the last unavailable slot
    while (currentTime.isBefore(to)) {
      DateTime slotEnd = currentTime.add(Duration(minutes: strideInMinutes));
      if (slotEnd.isAfter(to)) {
        slotEnd = to;
      }
      availableSlots.add(TimeSlotModel(from: currentTime, to: slotEnd));
      currentTime = slotEnd;
    }

    return availableSlots;
  } else {
    logger.e('Failed to load occupied timeslots : ${response.statusCode}');
  }

  return [];
}

Future<List<int>?> sendBookingRequest(
    List<BookingRequestModel> bookingRequests) async {
  print(jsonEncode(bookingRequests.map((e) => e.toJson()).toList()));
  final response = await apiFacade.sendRequest(RequestMethod.post, "book", true,
      body: jsonEncode(bookingRequests.map((e) => e.toJson()).toList()));

  if (response.statusCode == 200) {
    return [];
  }
  if (response.statusCode == 400) {
    print(response.body);
    return jsonDecode(response.body).cast<int>();
  }

  logger.e('Failed the request : ${response.statusCode}');

  return null;
}
