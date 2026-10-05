import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class WindowControls extends StatelessWidget {
  const WindowControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MinimizeWindowButton(
          colors: WindowButtonColors(
            iconNormal: Colors.black87,
            mouseOver: Colors.black12,
            mouseDown: Colors.black26,
            iconMouseOver: Colors.black,
            iconMouseDown: Colors.black,
          ),
        ),
        MaximizeWindowButton(
          colors: WindowButtonColors(
            iconNormal: Colors.black87,
            mouseOver: Colors.black12,
            mouseDown: Colors.black26,
            iconMouseOver: Colors.black,
            iconMouseDown: Colors.black,
          ),
        ),
        CloseWindowButton(
          colors: WindowButtonColors(
            iconNormal: Colors.black87,
            mouseOver: Colors.red,
            mouseDown: Colors.red.shade700,
            iconMouseOver: Colors.white,
            iconMouseDown: Colors.white,
          ),
        ),
      ],
    );
  }
}
