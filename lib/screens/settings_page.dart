import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TitleBarWithLeftNav(
        page: Pages.settings,
        children: [],
      ),
    );
  }
}
