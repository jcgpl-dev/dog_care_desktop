import 'package:flutter/material.dart';

class AppNavigationItem {
  final String label;
  final IconData icon;
  final String? route;
  final List<AppNavigationItem>? children;

  const AppNavigationItem({
    required this.label,
    required this.icon,
    this.route,
    this.children,
  });

  bool get hasChildren => children != null && children!.isNotEmpty;
}
