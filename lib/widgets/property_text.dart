import 'package:flutter/material.dart';

class PropertyText extends StatelessWidget {
  const PropertyText({
    Key? key,
    this.title,
    required this.text,
    this.textColor = const Color(0xffdbdbdb),
    this.titleFontSize = 15,
    this.mainFontSize = 20,
    this.maxLines,
    this.width = 300,
  }) : super(key: key);

  final String? title;
  final String text;
  final Color textColor;
  final double titleFontSize;
  final double mainFontSize;
  final int? maxLines;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          if (title != null) ...[
            Text(
              title!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 5),
          ],
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: mainFontSize,
            ),
            maxLines: maxLines,
          ),
        ],
      ),
    );
  }
}
