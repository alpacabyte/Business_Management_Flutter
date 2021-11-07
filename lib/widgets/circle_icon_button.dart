import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    Key? key,
    required Function onPressed,
    required this.toolTipText,
    this.preferBelow,
    required this.icon,
    this.iconSize,
    this.iconColor,
    this.buttonSize,
  })  : _onPressed = onPressed,
        super(key: key);

  final Function _onPressed;
  final String toolTipText;
  final bool? preferBelow;
  final IconData icon;
  final double? iconSize;
  final double? buttonSize;
  final Color? iconColor;

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
        onPressed: () async => _onPressed(),
        icon: Container(
          width: buttonSize ?? 45,
          height: buttonSize ?? 45,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: iconColor ?? const Color(0xffa81633))),
          child: Icon(
            icon,
            color: iconColor ?? const Color(0xffa81633),
            size: iconSize ?? 25,
          ),
        ),
        iconSize: buttonSize ?? 45,
      ),
    );
  }
}
