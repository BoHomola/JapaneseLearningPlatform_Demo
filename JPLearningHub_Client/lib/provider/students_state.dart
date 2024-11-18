import 'package:flutter/material.dart';
import 'package:jplearninghub/api/student_api.dart';
import 'package:jplearninghub/models/student_model.dart';
import 'package:jplearninghub/provider/auth_state.dart';

final studentsState = StudentsState();

class StudentsState extends ChangeNotifier {
  List<StudentModel> students = [];
  bool _loaded = false;

  void initialize() {
    authState.loginStream.stream.listen((event) {
      // _loadStudents();
    });
    authState.logoutStream.stream.listen((event) {
      _logout();
    });
  }

  void loadStudents() async {
    if (!_loaded) {
      students = await getStudents();
      _loaded = true;
      notifyListeners();
    }
  }

  void reloadStudents() async {
    students = await getStudents();
    notifyListeners();
  }

  void _logout() {
    students.clear();
    _loaded = false;
  }
}
