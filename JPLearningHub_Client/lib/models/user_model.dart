import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String firstName;
  String lastName;
  String avatarKey;
  String avatarUrl;
  String userId;
  String timeZone;
  String userType;

  UserModel(
      {required this.firstName,
      required this.lastName,
      required this.avatarKey,
      required this.avatarUrl,
      required this.userId,
      required this.timeZone,
      required this.userType});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  bool isTeacher() {
    return userType == "Teacher";
  }
}
