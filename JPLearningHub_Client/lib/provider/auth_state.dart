import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jplearninghub/main.dart';
import 'package:jplearninghub/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authState = AuthProvider();

class AuthProvider extends ChangeNotifier {
  final loginStream = StreamController.broadcast();
  final logoutStream = StreamController.broadcast();

  String? _token;
  bool get isLoggedIn => _isTokenValid();

  String getToken() {
    return _token!;
  }

  Future<void> initialize() async {
    logger.d('Initializing AuthState');
    try {
      Session? currenSession = supabase.auth.currentSession;
      if (currenSession != null) {
        _token = currenSession.accessToken;
      }
      print(_token);
    } catch (e) {
      _token = null;
    }
    notifyListeners();
    if (isLoggedIn) {
      loginStream.add(true);
    }
  }

  bool _isTokenValid() {
    return _token != null;
  }

  Future<bool> login(String email, String password) async {
    try {
      AuthResponse loginReponse = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (loginReponse.user == null || supabase.auth.currentSession == null) {
        return false;
      }

      _token = supabase.auth.currentSession!.accessToken;

      notifyListeners();
      if (isLoggedIn) {
        loginStream.add(true);
      }
      return isLoggedIn;
    } on Exception {
      return false;
    }
  }

  Future<void> logout() async {
    _token = null;
    supabase.auth.signOut();
    logoutStream.add(true);
    // profileStat.logout();
    notifyListeners();
  }

  Future<bool> register(String email, String password) async {
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (res.user != null) {
        _token = res.user!.id;
        notifyListeners();
        return true;
      }
    } catch (error) {
      //todo handle errors and propagating it to the user
      print('Error registering user: $error');
      return false;
    }

    return false;
  }
}
