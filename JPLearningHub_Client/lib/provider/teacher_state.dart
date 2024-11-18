import 'package:flutter/material.dart';
import 'package:jplearninghub/api/teacher_api.dart';
import 'package:jplearninghub/models/teacher_model.dart';
import 'package:jplearninghub/provider/auth_state.dart';

final teachersState = TeachersState();

class TeachersState extends ChangeNotifier {
  List<TeacherModel> teachers = [];
  bool _loaded = false;

  void initialize() {
    authState.loginStream.stream.listen((event) {
      loadTeachers();
    });
    authState.logoutStream.stream.listen((event) {
      _logout();
    });
  }

  void loadTeachers() async {
    if (!_loaded) {
      teachers = await getTeachers();
      _loaded = true;
      notifyListeners();
    }
  }

  void reloadTeachers() async {
    teachers = await getTeachers();
    notifyListeners();
  }

  void _logout() {
    teachers.clear();
    _loaded = false;
  }
}
