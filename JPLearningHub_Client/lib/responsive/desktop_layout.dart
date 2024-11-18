import 'package:flutter/material.dart';
import 'package:jplearninghub/widgets/side_menu.dart';
import 'package:responsive_framework/responsive_framework.dart';

class DesktopContent extends StatelessWidget {
  final Widget page;

  const DesktopContent({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.all(50), child: page);
  }
}

class ResponsiveLayout extends StatelessWidget {
  final Widget page;
  const ResponsiveLayout({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    if (ResponsiveBreakpoints.of(context).largerThan('EXPAND_SIDE_PANEL')) {
      return showSidePanel(context);
    } else {
      return hideSidePanel(context);
    }
  }

  Widget showSidePanel(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          const SideMenu(),
          Expanded(
              child: Container(padding: const EdgeInsets.all(50), child: page)),
        ],
      ),
    );
  }

  Widget hideSidePanel(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: null,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text("Learn with Shiori",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
      ),
      drawer: const SideMenu(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        padding: const EdgeInsets.all(10),
        child: page,
      ),
    );
  }
}
