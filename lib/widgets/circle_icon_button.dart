import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    Key? key,
    required Function onPressed,
    required this.toolTipText,
    this.preferBelow,
    required this.icon,
    this.iconSize = 25,
    this.iconColor = const Color(0xffa81633),
    this.buttonSize = 45,
  })  : _onPressed = onPressed,
        super(key: key);

  final Function _onPressed;
  final String toolTipText;
  final bool? preferBelow;
  final IconData icon;
  final double iconSize;
  final double buttonSize;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      triggerMode: TooltipTriggerMode.tap,
      verticalOffset: 30,
      preferBelow: preferBelow,
      height: 30,
      message: toolTipText,
      textStyle: const TextStyle(
        fontSize: 13,
        color: Colors.white,
      ),
      child: IconButton(
        onPressed: () => _onPressed(),
        icon: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: iconColor)),
          child: Icon(
            icon,
            color: iconColor,
            size: iconSize,
          ),
        ),
        iconSize: buttonSize,
      ),
    );
  }
}
