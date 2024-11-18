import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jplearninghub/page_router.dart';
import 'package:jplearninghub/provider/auth_state.dart';
import 'package:jplearninghub/provider/booking_state.dart';
import 'package:jplearninghub/provider/environment_provider.dart';
import 'package:jplearninghub/provider/lesson_state.dart';
import 'package:jplearninghub/provider/profile_state.dart';
import 'package:jplearninghub/provider/students_state.dart';
import 'package:jplearninghub/provider/teacher_state.dart';
import 'package:jplearninghub/provider/timezone_state.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await environmentProvider.initEnvironment();
  await initializeSupabase();
  await initializeProviders();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeState>(create: (context) => ThemeState()),
        ChangeNotifierProvider<UserState>.value(value: userState),
        ChangeNotifierProvider<LessonState>.value(value: lessonState),
        ChangeNotifierProvider<StudentsState>.value(value: studentsState),
        ChangeNotifierProvider<TeachersState>.value(value: teachersState),
        ChangeNotifierProvider<TimezoneState>.value(value: timezoneState),
        ChangeNotifierProvider<BookingProvider>(
            create: (context) => BookingProvider()),
        ChangeNotifierProvider<AuthProvider>.value(value: authState),
      ],
      child: const SafeArea(child: MyApp()),
    ),
  );
}

Future<void> initializeSupabase() async {
  await Supabase.initialize(
    url: 'https://vcztpxftnuyddouqtcqi.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZjenRweGZ0bnV5ZGRvdXF0Y3FpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjQ3MTQ1NjMsImV4cCI6MjA0MDI5MDU2M30.H9ovhSOTy9nzz6MWQQMY6bBy2tNMhDl6MjJCpyM3OKk',
  );
}

Future<void> initializeProviders() async {
  lessonState.initialize();
  userState.initialize();
  studentsState.initialize();
  teachersState.initialize();
  timezoneState.initialize();
  await authState.initialize();
}

// Access Supabase client
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeState>(builder: (context, themeProvider, child) {
      return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme:
              themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          title: 'Japanese with Shiori',
          builder: (context, child) => ResponsiveBreakpoints.builder(
                child: child!,
                breakpoints: [
                  const Breakpoint(start: 0, end: 850, name: MOBILE),
                  const Breakpoint(
                      start: 850, end: 860, name: 'EXPAND_SIDE_PANEL'),
                  const Breakpoint(start: 851, end: 1100, name: TABLET),
                  const Breakpoint(start: 1101, end: 1920, name: DESKTOP),
                  const Breakpoint(
                      start: 1921, end: double.infinity, name: '4K'),
                ],
              ),
          routerConfig: router);
    });
  }
}

class ThemeState extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  late SharedPreferences _prefs;

  ThemeState() {
    loadAndCheckAuthStatus();
  }

  Future<void> loadAndCheckAuthStatus() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }
}
