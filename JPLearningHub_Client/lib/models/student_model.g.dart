// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentModel _$StudentModelFromJson(Map<String, dynamic> json) => StudentModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      credits: (json['credits'] as num).toInt(),
    );

Map<String, dynamic> _$StudentModelToJson(StudentModel instance) =>
    <String, dynamic>{
      'user': instance.user,
      'credits': instance.credits,
    };
