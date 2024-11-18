import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jplearninghub/api/api_facade.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ApiEnvironment { dev, stag, prod }

final environmentProvider = EnvironmentProvider();

class EnvironmentProvider {
  ApiEnvironment _environment = ApiEnvironment.dev;
  Future<void> initEnvironment() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('environment')) {
      String? env = prefs.getString('environment');
      if (env != null) {
        switch (env) {
          case 'ApiEnvironment.dev':
            setEnvironment(ApiEnvironment.dev);
            break;
          case 'ApiEnvironment.stag':
            setEnvironment(ApiEnvironment.stag);
            break;
          case 'ApiEnvironment.prod':
            setEnvironment(ApiEnvironment.prod);
            break;
        }
      }
    } else {
      _setDevEnvironment();
    }
  }

  void setEnvironment(ApiEnvironment environment) {
    _environment = environment;
    switch (environment) {
      case ApiEnvironment.dev:
        _setDevEnvironment();
        break;
      case ApiEnvironment.stag:
        _setStagingEnvironment();
        break;
      case ApiEnvironment.prod:
        _setProductionEnvironment();
        break;
    }
    saveEnvironment();
  }

  ApiEnvironment getEnvironment() {
    return _environment;
  }

  void _setDevEnvironment() {
    apiFacade.serviceUrl = dotenv.env['SERVICE_URL_DEV']!;
  }

  void _setStagingEnvironment() {
    apiFacade.serviceUrl = dotenv.env['SERVICE_URL_STAG']!;
  }

  void _setProductionEnvironment() {
    apiFacade.serviceUrl = dotenv.env['SERVICE_URL_PROD']!;
  }

  void saveEnvironment() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('environment', _environment.toString());
  }
}
