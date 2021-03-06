import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

final buttonColors = WindowButtonColors(
  mouseOver: const Color(0xff42424f),
  mouseDown: const Color(0xff565666),
  iconNormal: Colors.grey.shade500,
  iconMouseOver: Colors.white,
  iconMouseDown: Colors.white,
);

final closeButtonColors = WindowButtonColors(
  mouseOver: const Color(0xFFD32F2F),
  mouseDown: const Color(0xFFB71C1C),
  iconNormal: Colors.grey.shade500,
  iconMouseOver: Colors.white,
  iconMouseDown: Colors.white,
);

class TitleBar extends StatelessWidget {
  const TitleBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: Row(
        children: [
          Expanded(child: MoveWindow()),
          MinimizeWindowButton(colors: buttonColors),
          MaximizeWindowButton(colors: buttonColors),
          CloseWindowButton(colors: closeButtonColors),
        ],
      ),
    );
  }
}
