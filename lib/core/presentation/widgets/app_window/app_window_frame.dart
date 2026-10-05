import 'package:flutter/material.dart';

import 'app_title_bar.dart';

class AppWindowFrame extends StatelessWidget {
  final Widget child;

  const AppWindowFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppTitleBar(),
          Expanded(child: child),
        ],
      ),
    );
  }
}
