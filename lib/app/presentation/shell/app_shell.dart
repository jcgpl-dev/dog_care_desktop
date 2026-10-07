import 'package:flutter/material.dart';

import '../../../core/presentation/widgets/app_window/app_window_frame.dart';
import 'app_sidebar.dart';

import 'app_top_bar.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AppWindowFrame(
      child: Row(
        children: [
          const AppSidebar(),
          Expanded(
            child: Column(
              children: [
                const AppTopBar(),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
