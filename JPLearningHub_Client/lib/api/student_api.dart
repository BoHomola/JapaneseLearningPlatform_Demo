import 'dart:convert';
import 'package:jplearninghub/api/api_facade.dart';
import 'package:jplearninghub/models/student_model.dart';
import 'package:jplearninghub/utils/logger.dart';

Future<List<StudentModel>> getStudents() async {
  var response =
      await apiFacade.sendRequest(RequestMethod.get, "students", true);
  if (response.statusCode == 200) {
    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
    return parsed
        .map<StudentModel>((json) => StudentModel.fromJson(json))
        .toList();
  } else {
    logger.e('Failed to load students : ${response.statusCode}');
  }

  return [];
}
