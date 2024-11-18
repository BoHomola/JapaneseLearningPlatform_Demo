import 'package:jplearninghub/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'student_model.g.dart';

@JsonSerializable()
class StudentModel {
  UserModel user;
  int credits;

  StudentModel({required this.user, required this.credits});

  Map<String, dynamic> toJson() => _$StudentModelToJson(this);
  factory StudentModel.fromJson(Map<String, dynamic> json) =>
      _$StudentModelFromJson(json);
}
