import 'package:business_management/helpers/colors.dart';
import 'package:business_management/widgets/circle_icon_button.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TitleBarWithLeftNav(
        page: Pages.home,
        children: [
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                "assets/images/logo.png",
                height: 200,
                fit: BoxFit.fitHeight,
              ),
              const Spacer(flex: 2),
              const Text(
                "ARS-KON PLASTİK",
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                ),
              ),
              InkWell(
                child: const Text(
                  "www.arskon.com",
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
                onTap: () => launch("www.arskon.com"),
              ),
              const Spacer(),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
