import 'package:business_management/main.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key? key,
    this.lenght,
    this.thickness = 1,
    this.isVertical = false,
    this.color = backgroundColorHeavy,
    this.margin,
  }) : super(key: key);

  final double? lenght;
  final double thickness;
  final bool isVertical;
  final Color color;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: isVertical ? lenght : thickness,
      width: isVertical ? thickness : lenght,
      color: color,
    );
  }
}
