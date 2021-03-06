import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/helpers/colors.dart';
import 'package:business_management/main.dart';
import 'package:business_management/screens/costumer/costumers_page.dart';
import 'package:business_management/screens/home/home_page.dart';
import 'package:business_management/screens/product/products_page.dart';
import 'package:business_management/screens/settings/settings_page.dart';
import 'package:business_management/screens/supplier/suppliers_page.dart';
import 'package:business_management/screens/vault/all_transactions.page.dart';
import 'package:business_management/screens/vault/vault_choose_page.dart';
import 'package:business_management/widgets/title_bar.dart';
import 'package:flutter/material.dart';

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
                    text: appLocalization(context).home,
                    isCurrentPage: page == Pages.home,
                    buttonNo: 0,
                  ),
                  _NavigationButtons(
                    icon: Icons.inventory_2_outlined,
                    text: appLocalization(context).products,
                    isCurrentPage: page == Pages.products,
                    buttonNo: 1,
                  ),
                  _NavigationButtons(
                    icon: Icons.person,
                    text: appLocalization(context).costumers,
                    isCurrentPage: page == Pages.costumers,
                    buttonNo: 2,
                  ),
                  _NavigationButtons(
                    icon: Icons.storefront,
                    text: appLocalization(context).suppliers,
                    isCurrentPage: page == Pages.suppliers,
                    buttonNo: 3,
                  ),
                  _NavigationButtons(
                    icon: Icons.point_of_sale,
                    text: appLocalization(context).vault,
                    isCurrentPage: page == Pages.vault,
                    buttonNo: 5,
                  ),
                  _NavigationButtons(
                    icon: Icons.settings,
                    text: appLocalization(context).settings,
                    isCurrentPage: page == Pages.settings,
                    buttonNo: 4,
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
  suppliers,
  settings,
  vault,
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
      SuppliersPage(),
      Settings(),
      VaultChoosePage(),
    ];
    return Column(
      children: [
        IconButton(
          icon: Icon(
            icon,
            color: isCurrentPage ? Colors.white : Colors.grey,
          ),
          iconSize: 35,
          onPressed: () => navigateWithoutAnim(context, pages[buttonNo]),
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
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16)),
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
