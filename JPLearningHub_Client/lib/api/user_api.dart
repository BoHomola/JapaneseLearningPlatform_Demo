import 'dart:convert';
import 'package:jplearninghub/api/api_facade.dart';
import 'package:jplearninghub/models/user_model.dart';

Future<UserModel?> getUser() async {
  var response = await apiFacade.sendRequest(RequestMethod.get, "user", true);
  if (response.statusCode == 200) {
    return UserModel.fromJson(jsonDecode(response.body));
  }

  return null;
}
