import 'dart:convert';
import 'package:jplearninghub/api/api_facade.dart';
import 'package:jplearninghub/models/teacher_model.dart';
import 'package:jplearninghub/utils/logger.dart';

Future<List<TeacherModel>> getTeachers() async {
  var response =
      await apiFacade.sendRequest(RequestMethod.get, "teachers", true);
  if (response.statusCode == 200) {
    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
    return parsed
        .map<TeacherModel>((json) => TeacherModel.fromJson(json))
        .toList();
  } else {
    logger.e('Failed to load teachers : ${response.statusCode}');
  }

  return [];
}
