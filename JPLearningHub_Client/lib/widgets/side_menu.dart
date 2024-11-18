import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jplearninghub/main.dart';
import 'package:jplearninghub/provider/auth_state.dart';
import 'package:jplearninghub/provider/profile_state.dart';
import 'package:jplearninghub/utils/logger.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shimmer/shimmer.dart';

class DrawerListTile extends StatelessWidget {
  final String title;

  final Icon? icon;
  final String? svgSrc;
  final String route;
  final bool selected;

  const DrawerListTile(
      {super.key,
      // For selecting those three line once press "Command+D"
      required this.title,
      required this.route,
      required this.selected,
      this.svgSrc,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.go(route);
        if (!ResponsiveBreakpoints.of(context).equals(DESKTOP)) {
          Navigator.pop(context);
        }
      },
      horizontalTitleGap: 15.0,
      selected: selected,
      selectedTileColor: Theme.of(context).focusColor,
      leading: svgSrc != null
          ? SvgPicture.asset(
              svgSrc.toString(),
              colorFilter:
                  const ColorFilter.mode(Colors.white54, BlendMode.srcIn),
              height: 16,
            )
          : icon ?? const Icon(Icons.error),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class SideMenu extends StatelessWidget {
  const SideMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String currentLocation = GoRouterState.of(context).uri.toString();
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SizedBox(
                  height: 200,
                  child: DrawerHeader(
                    child: drawHeader(),
                  ),
                ),
                DrawerListTile(
                  title: "Overview",
                  icon: const Icon(Icons.dashboard),
                  route: '/overview',
                  selected: currentLocation == '/overview',
                ),
                DrawerListTile(
                  title: "Homework",
                  icon: const Icon(Icons.task),
                  route: '/homework',
                  selected: currentLocation == '/homework',
                ),
                const Divider(),
                Consumer<UserState>(
                  builder: (context, profileState, child) {
                    if (!profileState.isUserLoaded) {
                      return Container();
                    } else if (profileState.getUserModel!.isTeacher()) {
                      //Teacher
                      return DrawerListTile(
                        title: "Students",
                        route: '/students',
                        icon: const Icon(Icons.people),
                        selected: currentLocation == '/students',
                      );
                    } else {
                      //Student
                      return DrawerListTile(
                        title: "Book a Lesson",
                        route: '/booking',
                        icon: const Icon(Icons.book),
                        selected: currentLocation == '/booking',
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
              selected: currentLocation == '/profile',
              selectedTileColor: Theme.of(context).focusColor,
              onTap: () async {
                context.go('/profile');
              },
              title: Text(
                "Profile",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              leading: const Icon(Icons.person)),
          Consumer<ThemeState>(
            builder: (context, themeProvider, child) {
              return SwitchListTile(
                title: const Text('Dark Mode'),
                value: themeProvider.isDarkMode,
                onChanged: (_) => themeProvider.toggleTheme(),
                secondary: Icon(themeProvider.isDarkMode
                    ? Icons.dark_mode
                    : Icons.light_mode),
              );
            },
          ),
          ListTile(
              onTap: () async {
                await authState.logout();
              },
              title: Text(
                "Logout",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              leading: const Icon(Icons.logout)),
        ],
      ),
    );
  }

  Column drawHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Consumer<UserState>(
          builder: (context, profileState, child) {
            if (!profileState.isUserLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                profileState.loadUserIfNeeded();
              });
              return const CircleAvatar(
                radius: 40.0,
                child: Icon(Icons.person),
              );
            }
            return ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: CachedNetworkImage(
                width: 80,
                height: 80,
                cacheKey: profileState.getUserModel!.avatarKey,
                imageUrl: profileState.getUserModel!.avatarUrl,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 80,
                    height: 80,
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) {
                  logger.e(error.toString());
                  return const Icon(Icons.error);
                },
              ),
            );
            // );
          },
        ),
        const SizedBox(height: 10.0),
        Consumer<UserState>(builder: (context, profileState, child) {
          if (profileState.isUserLoaded) {
            return Column(children: [
              Text(
                  "${profileState.getUserModel!.firstName} ${profileState.getUserModel!.lastName}"),
              Text(profileState.getUserModel!.userType),
              Text(profileState.getUserModel!.timeZone),
            ]);
          }
          return const Center();
        }),
      ],
    );
  }
}
