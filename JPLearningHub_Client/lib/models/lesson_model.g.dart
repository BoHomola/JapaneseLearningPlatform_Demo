// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonModel _$LessonModelFromJson(Map<String, dynamic> json) => LessonModel(
      teacher: UserModel.fromJson(json['teacher'] as Map<String, dynamic>),
      students: (json['students'] as List<dynamic>)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      startDate: DateTime.parse(json['startDate'] as String),
      lessonMessage: json['lessonMessage'] as String,
      endDate: DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$LessonModelToJson(LessonModel instance) =>
    <String, dynamic>{
      'teacher': instance.teacher,
      'students': instance.students,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'lessonMessage': instance.lessonMessage,
    };

TeachingHoursModel _$TeachingHoursModelFromJson(Map<String, dynamic> json) =>
    TeachingHoursModel(
      fromHour: (json['fromHour'] as num).toInt(),
      fromMinute: (json['fromMinute'] as num).toInt(),
      toHour: (json['toHour'] as num).toInt(),
      toMinute: (json['toMinute'] as num).toInt(),
      effectiveDate: DateTime.parse(json['effectiveDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$TeachingHoursModelToJson(TeachingHoursModel instance) =>
    <String, dynamic>{
      'fromHour': instance.fromHour,
      'fromMinute': instance.fromMinute,
      'toHour': instance.toHour,
      'toMinute': instance.toMinute,
      'effectiveDate': instance.effectiveDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
    };

TimeSlotModel _$TimeSlotModelFromJson(Map<String, dynamic> json) =>
    TimeSlotModel(
      from: DateTime.parse(json['from'] as String),
      to: DateTime.parse(json['to'] as String),
    );

Map<String, dynamic> _$TimeSlotModelToJson(TimeSlotModel instance) =>
    <String, dynamic>{
      'from': instance.from.toIso8601String(),
      'to': instance.to.toIso8601String(),
    };

TimeslotsModel _$TimeslotsModelFromJson(Map<String, dynamic> json) =>
    TimeslotsModel(
      unavailableTimeslots: (json['unavailableTimeslots'] as List<dynamic>)
          .map((e) => TimeSlotModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TimeslotsModelToJson(TimeslotsModel instance) =>
    <String, dynamic>{
      'unavailableTimeslots': instance.unavailableTimeslots,
    };

BookingRequestModel _$BookingRequestModelFromJson(Map<String, dynamic> json) =>
    BookingRequestModel(
      bookingIndex: (json['bookingIndex'] as num).toInt(),
      startDate: DateTime.parse(json['startDate'] as String),
      lessonLength: $enumDecode(_$LessonLengthEnumMap, json['lessonLength']),
      teacherId: json['teacherId'] as String,
      lessonMessage: json['lessonMessage'] as String?,
    );

Map<String, dynamic> _$BookingRequestModelToJson(
        BookingRequestModel instance) =>
    <String, dynamic>{
      'bookingIndex': instance.bookingIndex,
      'startDate': instance.startDate.toIso8601String(),
      'lessonLength': _$LessonLengthEnumMap[instance.lessonLength]!,
      'teacherId': instance.teacherId,
      'lessonMessage': instance.lessonMessage,
    };

const _$LessonLengthEnumMap = {
  LessonLength.short: 0,
  LessonLength.long: 1,
};
