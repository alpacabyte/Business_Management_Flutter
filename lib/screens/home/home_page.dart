import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TitleBarWithLeftNav(
        page: Pages.home,
        children: [
          /* Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  Provider.of<ProductsData>(context, listen: false).saveJson();
                },
                child: const Text("Create Back-up"),
              ),
            ),
          ), */
        ],
      ),
    );
  }
}