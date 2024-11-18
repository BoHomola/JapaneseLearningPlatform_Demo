import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jplearninghub/pages/book_lesson/layout/booking_calendar_screen.dart';
import 'package:jplearninghub/pages/book_lesson/layout/list_bookings_screen.dart';
import 'package:jplearninghub/pages/homework/desktop_homework_screen.dart';
import 'package:jplearninghub/pages/login/login_screen.dart';
import 'package:jplearninghub/pages/overview/layout/desktop_overview_screen.dart';
import 'package:jplearninghub/pages/profile/desktop_profile_screen.dart';
import 'package:jplearninghub/pages/splash/after_splash_screen.dart';
import 'package:jplearninghub/pages/students/desktop_students_screen.dart';
import 'package:jplearninghub/provider/auth_state.dart';
import 'package:jplearninghub/responsive/desktop_layout.dart';

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  refreshListenable: authState,
  redirect: (BuildContext context, GoRouterState state) async {
    final isLoggingIn = state.matchedLocation == '/login';
    final isSplash = state.matchedLocation == '/splash';

    if (isSplash) {
      return null;
    }

    if (!authState.isLoggedIn) {
      return isLoggingIn ? null : '/login';
    }

    if (isLoggingIn) {
      return '/overview';
    }

    if (state.uri.toString() == state.matchedLocation) {
      return null;
    }

    return state.uri.toString();
  },
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => SplashScreen(
        onInitComplete: () {
          if (authState.isLoggedIn) {
            context.go('/overview');
          } else {
            context.go('/login');
          }
        },
      ),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(
        onLogin: (String email, String password) {
          authState.login(email, password);
          context.go('/overview');
        },
      ),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ResponsiveLayout(page: child);
      },
      routes: [
        GoRoute(
          path: '/overview',
          pageBuilder: (context, state) => NoTransitionPage<void>(
              key: ValueKey('overview-${state.uri.toString()}'),
              child: const DesktopOverviewScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => NoTransitionPage<void>(
              key: ValueKey('profile-${state.uri.toString()}'),
              child: const DesktopProfileScreen()),
        ),
        GoRoute(
          path: '/homework',
          pageBuilder: (context, state) => NoTransitionPage<void>(
              key: ValueKey('homework-${state.uri.toString()}'),
              child: const DesktopHomeworkScreen()),
        ),
        GoRoute(
            path: '/booking',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: ValueKey('lesson_book-${state.uri.toString()}'),
                child: const ListBookingsScreen()),
            routes: [
              GoRoute(
                  path: 'new',
                  pageBuilder: (context, state) => NoTransitionPage<void>(
                        key: ValueKey('new_booking-${state.uri.toString()}'),
                        child: const BookingCalendarScreen(),
                      )),
            ]),
        GoRoute(
            path: '/students',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                  key: ValueKey('students-${state.uri.toString()}'),
                  child: const DesktopStudentScreen(),
                )),
      ],
    ),
  ],
);

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');
