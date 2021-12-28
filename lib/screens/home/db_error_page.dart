import 'package:business_management/main.dart';
import 'package:business_management/widgets/title_bar.dart';
import 'package:flutter/material.dart';

class DBErrorWidget extends StatelessWidget {
  const DBErrorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const TitleBar(),
            const Spacer(),
            Text(
              appLocalization(context).dataBaseError,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
