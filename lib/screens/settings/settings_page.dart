import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TitleBarWithLeftNav(
        page: Pages.settings,
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
