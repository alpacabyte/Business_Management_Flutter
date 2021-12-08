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
          children: const [
            TitleBar(),
            Spacer(),
            Text(
              "Data Base Error!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}
