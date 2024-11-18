import 'package:flutter/material.dart';
import 'package:jplearninghub/widgets/side_menu.dart';

class MobileContent extends StatelessWidget {
  final Widget page;
  const MobileContent({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.all(10), child: page);
  }
}

class MobileLayout extends StatelessWidget {
  final Widget page;
  const MobileLayout({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
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
      body: MobileContent(
        page: page,
      ),
    );
  }
}
