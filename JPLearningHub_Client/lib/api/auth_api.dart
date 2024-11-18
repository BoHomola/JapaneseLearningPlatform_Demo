import 'dart:convert';
import 'package:jplearninghub/api/api_facade.dart';
import 'package:jplearninghub/models/login_model.dart';

Future<LoginModel?> sendLoginRequest(String email, String password) async {
  final user = LoginData(email: email, password: password);
  final response = await apiFacade.sendRequest(
      RequestMethod.post, "login", false,
      body: jsonEncode(user.toJson()));

  if (response.statusCode == 200) {
    return LoginModel.fromJson(jsonDecode(response.body));
  }

  return null;
}
