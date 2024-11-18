import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class DesktopHomeworkScreen extends StatelessWidget {
  const DesktopHomeworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: const ResponsiveScaledBox(
        width: 800,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          ContainerTest(),
          ContainerTest(),
          ContainerTest(),
          ContainerTest(),
          ContainerTest(),
        ]),
      ),
    );
  }
}

class ContainerTest extends StatelessWidget {
  const ContainerTest({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.amber,
        padding: const EdgeInsets.all(20),
        child: const Text('DesktopHomeworkScreen'));
  }
}
