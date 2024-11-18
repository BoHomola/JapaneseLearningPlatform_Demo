import 'package:flutter/material.dart';
import 'package:jplearninghub/api/lesson_api.dart';
import 'package:jplearninghub/models/lesson_model.dart';
import 'package:jplearninghub/provider/auth_state.dart';
import 'package:jplearninghub/utils/logger.dart';

final lessonState = LessonState();

class LessonState extends ChangeNotifier {
  List<LessonModel> _lessons = [];

  List<LessonModel> get lessons => _lessons;

  void initialize() {
    logger.d('Initializing LessonState');
    authState.loginStream.stream.listen((event) {
      loadLessons();
    });
    authState.logoutStream.stream.listen((event) {
      logout();
    });
  }

  void loadLessons() async {
    logger.d('Loading lessons');
    _lessons = await getLessons();
    notifyListeners();
  }

  void logout() {
    _lessons.clear();
    notifyListeners();
  }
}
