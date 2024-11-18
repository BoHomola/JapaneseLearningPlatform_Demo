import 'package:flutter/material.dart';
import 'package:jplearninghub/provider/auth_state.dart';
import 'package:jplearninghub/provider/profile_state.dart';
import 'package:jplearninghub/utils/logger.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

final timezoneState = TimezoneState();

class TimezoneState extends ChangeNotifier {
  String userTimezoneString = '';
  late tz.Location userTimezone;
  bool isLoaded = false;

  void initialize() {
    loadTimezones();
    userState.userLoadStream.stream.listen((event) {
      _onUserLoad();
    });
    authState.logoutStream.stream.listen((event) {
      isLoaded = false;
      notifyListeners();
    });
  }

  void loadTimezones() async {
    tz.initializeTimeZones();
  }

  void _onUserLoad() {
    userTimezoneString = userState.getUserModel!.timeZone;
    userTimezone = tz.getLocation(userTimezoneString);
    tz.setLocalLocation(userTimezone);
    isLoaded = true;
    notifyListeners();
  }

  DateTime convertUtcToLocalTime(DateTime dateTime) {
    if (!dateTime.isUtc) {
      logger.e('DateTime is not UTC: $dateTime');
      dateTime = dateTime.toUtc();
    }
    return tz.TZDateTime.from(dateTime, userTimezone);
  }

  DateTime getLocalTime() {
    return tz.TZDateTime.now(userTimezone);
  }

  int getOffsetInMinutes() {
    return userTimezone.currentTimeZone.offset ~/ (1000 * 60);
  }
}
