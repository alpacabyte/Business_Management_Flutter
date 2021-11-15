import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/costumer.dart';
import 'package:business_management/models/costumer_data.dart';
import 'package:business_management/screens/costumer_edit_page.dart';
import 'package:business_management/screens/costumers_page.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CostumerPage extends StatefulWidget {
  const CostumerPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CostumerPage> createState() => _CostumerPageState();
}

class _CostumerPageState extends State<CostumerPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Consumer<CostumersData>(
        builder: (context, productsData, child) {
          Costumer currentCostumer = productsData.currentCostumer!;
          return TitleBarWithLeftNav(
            page: Pages.costumers,
            children: [
              const Spacer(),
              _CostumerProperties(currentCostumer: currentCostumer),
              const Spacer(),
              _ProductPageButtons(currentCostumer: currentCostumer),
              const Spacer(),
            ],
          );
        },
      ),
    );
  }
}

class _CostumerProperties extends StatelessWidget {
  const _CostumerProperties({
    Key? key,
    required this.currentCostumer,
  }) : super(key: key);

  final Costumer currentCostumer;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColorLight,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 1000,
        height: SizeConfig.safeBlockVertical * 85,
        padding: const EdgeInsets.only(top: 25, bottom: 25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              SizedBox(
                width: 650,
                height: 50,
                child: FittedBox(
                  child: Text(
                    currentCostumer.corporateTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xffdbdbdb),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 25),
                height: 5,
                width: 750,
                color: backgroundColorHeavy,
              ),
              Wrap(
                spacing: 150,
                runSpacing: 45,
                children: [
                  _PropertyText(
                    title: "E-Mail",
                    text: currentCostumer.email,
                  ),
                  _PropertyText(
                    title: "Phone Number",
                    text: currentCostumer.phoneNumber,
                  ),
                  _PropertyText(
                    title: "Tax Administration",
                    text: currentCostumer.taxAdministration,
                  ),
                  _PropertyText(
                    title: "Tax Number",
                    text: currentCostumer.taxNumber,
                  ),
                  _PropertyText(
                    title: "Created",
                    text: currentCostumer.creationDate,
                  ),
                  _PropertyText(
                    title: "Last Modified",
                    text: currentCostumer.lastModifiedDate ?? "-",
                  ),
                  _PropertyText(
                    title: "Address",
                    text: currentCostumer.address,
                  ),
                  _PropertyText(
                    title: "Total Balance",
                    text: "${currentCostumer.balance.toString()} TL",
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Align(
                alignment: const Alignment(0.75, 0),
                child: Text(
                  "Product No: ${currentCostumer.costumerIndex}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 25),
                height: 5,
                width: 750,
                color: backgroundColorHeavy,
              ),
              const Text(
                "Last Transactions",
                style: TextStyle(color: Color(0xffdbdbdb), fontSize: 20),
              ),
              Column(
                children: [],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PropertyText extends StatelessWidget {
  const _PropertyText({
    Key? key,
    required this.title,
    required this.text,
  }) : super(key: key);

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xffdbdbdb), fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class _ProductPageButtons extends StatelessWidget {
  const _ProductPageButtons({
    Key? key,
    required this.currentCostumer,
  }) : super(key: key);

  final Costumer currentCostumer;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(15),
      color: backgroundColorLight,
      child: SizedBox(
        width: 200,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              verticalOffset: 30,
              preferBelow: false,
              height: 30,
              message: 'Edit product',
              textStyle: const TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
              child: IconButton(
                onPressed: () => navigateWithoutAnim(
                  context,
                  CostumerEditPage(
                    currentCostumer: currentCostumer,
                  ),
                ),
                icon: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xffa81633))),
                  child: const Icon(
                    Icons.edit,
                    color: Color(0xffa81633),
                    size: 25,
                  ),
                ),
                iconSize: 45,
              ),
            ),
            Container(
              height: 2,
              width: 150,
              color: Colors.black26,
            ),
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              verticalOffset: 30,
              height: 30,
              message: 'Go back',
              textStyle: const TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
              child: IconButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, anim1, anim2) =>
                        const CostumersPage(),
                    transitionDuration: Duration.zero,
                  ),
                ),
                icon: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xffa81633))),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color(0xffa81633),
                    size: 30,
                  ),
                ),
                iconSize: 45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
