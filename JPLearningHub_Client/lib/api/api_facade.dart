import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jplearninghub/provider/auth_state.dart';
import 'package:jplearninghub/utils/logger.dart';

final apiFacade = ApiFacade();

enum RequestMethod { get, post, put, delete }

class ApiFacade {
  String serviceUrl = '';
  Future<http.Response> sendRequest(
    RequestMethod requestMethod,
    String endpoint,
    bool isAuthRequired, {
    String body = '',
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      if (isAuthRequired) {
        bool isTokenValid = authState.isLoggedIn;
        if (!isTokenValid) {
          await authState.logout();
          return Future.error(Exception('Invalid token'));
        }
      }

      final headers = <String, String>{};
      headers['Content-Type'] = 'application/json; charset=UTF-8';
      if (isAuthRequired) {
        headers['Authorization'] = 'Bearer ${authState.getToken()}';
      }

      var uri = Uri.parse(serviceUrl + endpoint);

      // If queryParameters are provided, add them to the URI
      if (queryParameters != null && queryParameters.isNotEmpty) {
        uri = uri.replace(
            queryParameters: queryParameters
                .map((key, value) => MapEntry(key, value.toString())));
      }

      final http.Response response;
      switch (requestMethod) {
        case RequestMethod.get:
          response = await http.get(uri, headers: headers);
          break;
        case RequestMethod.post:
          response = await http.post(uri, headers: headers, body: body);
          break;
        case RequestMethod.put:
          response = await http.put(uri, headers: headers, body: body);
          break;
        case RequestMethod.delete:
          response = await http.delete(uri, headers: headers, body: body);
          break;
      }

      if (response.statusCode == 401) {
        await authState.logout();
      }
      return response;
    } catch (e) {
      logger.d(e);
      return Future.error(e);
    }
  }

  Future<http.StreamedResponse> sendFile(
      String endpoint, File file, Function(UploadProgress) onProgress) async {
    try {
      if (!authState.isLoggedIn) {
        await authState.logout();
        return Future.error(Exception('Invalid token'));
      }

      final headers = <String, String>{};
      headers['Authorization'] = 'Bearer ${authState.getToken()}';

      var uri = Uri.parse(serviceUrl + endpoint);
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(headers);

      var multipartFile = await http.MultipartFile.fromPath('file', file.path);
      request.files.add(multipartFile);

      var totalBytes = file.lengthSync();
      var bytesSent = 0;

      var response = await request.send().then((response) {
        return response;
      });

      response.stream.listen((List<int> chunk) {
        bytesSent += chunk.length;
        onProgress(UploadProgress(bytesSent, totalBytes));
      });

      if (response.statusCode == 401) {
        await authState.logout();
      }

      return response;
    } catch (e) {
      logger.d(e);
      return Future.error(e);
    }
  }
}

class UploadProgress {
  final int sent;
  final int total;
  UploadProgress(this.sent, this.total);
}
