import 'package:flutter/material.dart';
import 'app_title_bar.dart';

class AppWindowFrame extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final bool extendBodyBehindTitleBar;
  final bool isDarkTitleBar;

  const AppWindowFrame({
    super.key,
    required this.child,
    this.backgroundColor = Colors.transparent,
    this.extendBodyBehindTitleBar = true,
    this.isDarkTitleBar = false,
  });

  @override
  Widget build(BuildContext context) {
    final titleBar = AppTitleBar(isDark: isDarkTitleBar);

    if (extendBodyBehindTitleBar) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            Positioned.fill(child: child),
            Positioned(top: 0, left: 0, right: 0, child: titleBar),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          titleBar,
          Expanded(child: child),
        ],
      ),
    );
  }
}
