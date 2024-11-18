import 'package:flutter/material.dart';
import 'package:jplearninghub/widgets/side_menu.dart';

class TabletContent extends StatelessWidget {
  final Widget page;
  const TabletContent({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.all(10), child: page);
  }
}

class TabletLayout extends StatelessWidget {
  final Widget page;
  const TabletLayout({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const SideMenu(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: TabletContent(page: page),
    );
  }
}
