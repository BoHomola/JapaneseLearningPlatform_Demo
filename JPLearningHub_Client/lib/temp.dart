import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const MyApp());

final GoRouter _router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithDrawer(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const HomePage(),
          ),
        ),
        GoRoute(
            path: '/photos',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const PhotosPage(),
                )),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const SettingsPage(),
          ),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData.dark(),
      title: 'Japanese with Shiori',
    );
  }
}

class ScaffoldWithDrawer extends StatelessWidget {
  final Widget child;

  const ScaffoldWithDrawer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My App')),
      drawer: const AppDrawer(),
      body: child,
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentLocation = GoRouterState.of(context).uri.toString();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Menu'),
          ),
          DrawerItem(
            icon: Icons.home,
            title: 'Home',
            route: '/home',
            isSelected: currentLocation == '/home',
          ),
          DrawerItem(
            icon: Icons.photo,
            title: 'Photos',
            route: '/photos',
            isSelected: currentLocation == '/photos',
          ),
          DrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            route: '/settings',
            isSelected: currentLocation == '/settings',
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final bool isSelected;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.route,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : null),
      title:
          Text(title, style: TextStyle(color: isSelected ? Colors.blue : null)),
      onTap: () {
        context.go(route);
        Navigator.pop(context); // Close the drawer
      },
      selected: isSelected,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Home Page'));
  }
}

class PhotosPage extends StatelessWidget {
  const PhotosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Photos Page'));
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Settings Page'));
  }
}
