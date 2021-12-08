import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/costumer_data.dart';
import 'package:business_management/models/product_data.dart';
import 'package:business_management/screens/costumer/costumers_page.dart';
import 'package:business_management/screens/home/home_page.dart';
import 'package:business_management/screens/product/products_page.dart';
import 'package:business_management/screens/settings/settings_page.dart';
import 'package:business_management/widgets/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeftNavigationBar extends StatelessWidget {
  const LeftNavigationBar({
    Key? key,
    required this.page,
  }) : super(key: key);

  final Pages page;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      width: 100,
      child: Stack(
        children: [
          Align(
            alignment: const Alignment(0, -0.1),
            child: SizedBox(
              height: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavigationButtons(
                    icon: Icons.home,
                    text: "Home",
                    isCurrentPage: page == Pages.home,
                    buttonNo: 0,
                  ),
                  _NavigationButtons(
                    icon: Icons.inventory_2_outlined,
                    text: "Products",
                    isCurrentPage: page == Pages.products,
                    buttonNo: 1,
                  ),
                  _NavigationButtons(
                    icon: Icons.person,
                    text: "Costumers",
                    isCurrentPage: page == Pages.costumers,
                    buttonNo: 2,
                  ),
                  _NavigationButtons(
                    icon: Icons.settings,
                    text: "Settings",
                    isCurrentPage: page == Pages.settings,
                    buttonNo: 3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum Pages {
  home,
  products,
  costumers,
  settings,
}

class _NavigationButtons extends StatelessWidget {
  const _NavigationButtons({
    Key? key,
    required this.icon,
    required this.text,
    required this.isCurrentPage,
    required this.buttonNo,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final bool isCurrentPage;
  final int buttonNo;

  @override
  Widget build(BuildContext context) {
    const List<Widget> pages = [
      HomePage(),
      ProductsPage(),
      CostumersPage(),
      Settings(),
    ];
    return Column(
      children: [
        IconButton(
          icon: Icon(
            icon,
            color: isCurrentPage ? Colors.white : Colors.grey,
          ),
          iconSize: 35,
          onPressed: () {
            if (buttonNo == 1) {
              Provider.of<ProductsData>(context, listen: false).getProducts();
            } else if (buttonNo == 2) {
              Provider.of<CostumersData>(context, listen: false)
                  .getCostumersList();
            }
            navigateWithoutAnim(context, pages[buttonNo]);
          },
        ),
        if (isCurrentPage)
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.75,
            ),
          )
        else
          const SizedBox(height: 20),
      ],
    );
  }
}

class TitleBarWithLeftNav extends StatelessWidget {
  const TitleBarWithLeftNav({
    Key? key,
    required List<Widget> children,
    required this.page,
  })  : _children = children,
        super(key: key);

  final List<Widget> _children;
  final Pages page;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TitleBar(),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LeftNavigationBar(page: page),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(16)),
                    color: backgroundColorHeavy,
                  ),
                  child: Row(
                    children: [
                      ..._children,
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
