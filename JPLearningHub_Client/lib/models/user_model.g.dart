// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      avatarKey: json['avatarKey'] as String,
      avatarUrl: json['avatarUrl'] as String,
      userId: json['userId'] as String,
      timeZone: json['timeZone'] as String,
      userType: json['userType'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'avatarKey': instance.avatarKey,
      'avatarUrl': instance.avatarUrl,
      'userId': instance.userId,
      'timeZone': instance.timeZone,
      'userType': instance.userType,
    };
