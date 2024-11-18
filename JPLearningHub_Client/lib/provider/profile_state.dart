import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jplearninghub/api/user_api.dart';
import 'package:jplearninghub/models/user_model.dart';
import 'package:jplearninghub/provider/auth_state.dart';
import 'package:jplearninghub/utils/logger.dart';

final userState = UserState();

class UserState extends ChangeNotifier {
  UserModel? _userModel;
  bool _isLoading = false;

  UserModel? get getUserModel => _userModel;

  bool get isUserLoaded => _userModel != null;
  bool get isLoading => _isLoading;

  final userLoadStream = StreamController.broadcast();

  void initialize() {
    authState.loginStream.stream.listen((event) {
      loadUserIfNeeded();
    });
    authState.logoutStream.stream.listen((event) {
      logout();
    });
  }

  void logout() {
    _userModel = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadUserIfNeeded() async {
    if (!authState.isLoggedIn) {
      return;
    }
    if (_userModel != null || _isLoading) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _userModel = await getUser();
      userLoadStream.add(true);
    } catch (e) {
      logger.e('Failed to load user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
