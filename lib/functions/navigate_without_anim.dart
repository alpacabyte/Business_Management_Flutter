import 'package:flutter/material.dart';

Future<dynamic> navigateWithoutAnim(BuildContext context, Widget page) {
  return Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, anim1, anim2) => page,
      transitionDuration: Duration.zero,
    ),
  );
}
