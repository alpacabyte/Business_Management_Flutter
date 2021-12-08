import 'dart:io';

import 'package:business_management/models/product_data.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TitleBarWithLeftNav(
        page: Pages.home,
        children: [
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  Provider.of<ProductsData>(context, listen: false).saveJson();
                },
                child: const Text("Create Back-up"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
