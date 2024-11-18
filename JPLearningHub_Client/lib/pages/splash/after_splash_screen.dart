import 'package:flutter/material.dart';

class SplashScreenContent extends StatelessWidget {
  final Widget page;

  const SplashScreenContent({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.all(10), child: page);
  }
}

class SplashScreen extends StatelessWidget {
  final VoidCallback onInitComplete;
  const SplashScreen({super.key, required this.onInitComplete});

  @override
  Widget build(BuildContext context) {
    onInitComplete();
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
