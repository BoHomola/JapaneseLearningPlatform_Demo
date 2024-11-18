import 'package:jplearninghub/models/user_model.dart';
import 'package:jplearninghub/provider/booking_state.dart';
import 'package:json_annotation/json_annotation.dart';
part 'lesson_model.g.dart';

@JsonSerializable()
class LessonModel {
  UserModel teacher;
  List<UserModel> students;
  DateTime startDate;
  DateTime endDate;
  String lessonMessage;

  LessonModel({
    required this.teacher,
    required this.students,
    required this.startDate,
    required this.lessonMessage,
    required this.endDate,
  });
  factory LessonModel.fromJson(Map<String, dynamic> json) =>
      _$LessonModelFromJson(json);
  Map<String, dynamic> toJson() => _$LessonModelToJson(this);
}

@JsonSerializable()
class TeachingHoursModel {
  int fromHour;
  int fromMinute;
  int toHour;
  int toMinute;
  DateTime effectiveDate;
  DateTime endDate;

  TeachingHoursModel({
    required this.fromHour,
    required this.fromMinute,
    required this.toHour,
    required this.toMinute,
    required this.effectiveDate,
    required this.endDate,
  });

  factory TeachingHoursModel.fromJson(Map<String, dynamic> json) =>
      _$TeachingHoursModelFromJson(json);
  Map<String, dynamic> toJson() => _$TeachingHoursModelToJson(this);
}

@JsonSerializable()
class TimeSlotModel {
  DateTime from;
  DateTime to;

  TimeSlotModel({
    required this.from,
    required this.to,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotModelFromJson(json);
  Map<String, dynamic> toJson() => _$TimeSlotModelToJson(this);
}

@JsonSerializable()
class TimeslotsModel {
  List<TimeSlotModel> unavailableTimeslots;

  TimeslotsModel({
    required this.unavailableTimeslots,
  });

  factory TimeslotsModel.fromJson(Map<String, dynamic> json) =>
      _$TimeslotsModelFromJson(json);
  Map<String, dynamic> toJson() => _$TimeslotsModelToJson(this);
}

@JsonSerializable()
class BookingRequestModel {
  final int bookingIndex;
  final DateTime startDate;
  final LessonLength lessonLength;
  final String teacherId;
  final String? lessonMessage;

  BookingRequestModel({
    required this.bookingIndex,
    required this.startDate,
    required this.lessonLength,
    required this.teacherId,
    required this.lessonMessage,
  });

  factory BookingRequestModel.fromJson(Map<String, dynamic> json) =>
      _$BookingRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookingRequestModelToJson(this);
}
