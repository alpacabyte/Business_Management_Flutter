import 'dart:io';
import 'package:business_management/main.dart';
import 'package:flutter/material.dart';

class ImageFromFile extends StatelessWidget {
  const ImageFromFile({
    Key? key,
    required this.image,
    required this.width,
    required this.height,
    this.fontSize,
    this.errorWidth,
    this.errorColor,
  }) : super(key: key);

  final String? image;
  final double width, height;
  final double? fontSize;
  final double? errorWidth;
  final Color? errorColor;

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return Image.file(
        File(image!),
        fit: BoxFit.contain,
        width: width,
        height: height,
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return errorContainer("Photo not found");
        },
      );
    } else {
      return errorContainer("No Photo");
    }
  }

  Container errorContainer(String error) {
    return Container(
      width: errorWidth ?? height,
      height: height,
      decoration: BoxDecoration(
        color: errorColor ?? backgroundColorHeavy,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(
        error,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize ?? 15,
        ),
      ),
    );
  }
}
