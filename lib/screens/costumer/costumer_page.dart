import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/costumer.dart';
import 'package:business_management/models/costumer_data.dart';
import 'package:business_management/models/transaction.dart';
import 'package:business_management/screens/costumer/costumer_edit_page.dart';
import 'package:business_management/screens/costumer/costumers_page.dart';
import 'package:business_management/screens/transaction/costumer_transactions_page.dart';
import 'package:business_management/widgets/circle_icon_button.dart';
import 'package:business_management/widgets/custom_divider.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:business_management/widgets/property_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CostumerPage extends StatelessWidget {
  const CostumerPage({
    Key? key,
  }) : super(key: key);

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
              const _ProductPageButtons(),
              const SizedBox(width: 20),
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
      child: SizedBox(
        width: 1000,
        height: SizeConfig.safeBlockVertical * 85,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 25),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PropertyText(
                      text: currentCostumer.corporateTitle,
                      textColor: const Color(0xffdbdbdb),
                      mainFontSize: 35,
                      maxLines: 2,
                      width: 500,
                    ),
                    const CustomDivider(
                      lenght: 750,
                      thickness: 5,
                      margin: EdgeInsets.symmetric(vertical: 25),
                    ),
                    _Properties(currentCostumer: currentCostumer),
                    const SizedBox(height: 25),
                    Align(
                      alignment: const Alignment(0.75, 0),
                      child: Text(
                        "Costumer No: ${currentCostumer.costumerIndex}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const CustomDivider(
                      lenght: 750,
                      thickness: 5,
                      margin: EdgeInsets.symmetric(vertical: 25),
                    ),
                    const Text(
                      "Last Transactions",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _LastTransactions(currentCostumer: currentCostumer),
                  ],
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0.98, -0.98),
              child: CircleIconButton(
                onPressed: () => Provider.of<CostumersData>(context, listen: false).createExcelFromThisCostumer(),
                toolTipText: 'Create excel from this costumer',
                icon: Icons.content_copy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Properties extends StatelessWidget {
  const _Properties({
    Key? key,
    required this.currentCostumer,
  }) : super(key: key);

  final Costumer currentCostumer;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 150,
      runSpacing: 45,
      children: [
        PropertyText(
          title: "E-Mail",
          text: currentCostumer.email,
        ),
        PropertyText(
          title: "Phone Number",
          text: currentCostumer.phoneNumber,
        ),
        PropertyText(
          title: "Tax Administration",
          text: currentCostumer.taxAdministration,
        ),
        PropertyText(
          title: "Tax Number",
          text: currentCostumer.taxNumber,
        ),
        PropertyText(
          title: "Created",
          text: currentCostumer.creationDate,
        ),
        PropertyText(
          title: "Last Modified",
          text: currentCostumer.lastModifiedDate ?? "-",
        ),
        PropertyText(
          title: "Address",
          text: currentCostumer.address,
        ),
        PropertyText(
          title: "Total Balance",
          text: "${currentCostumer.balance.toString()} TL",
          textColor: currentCostumer.balance > 0
              ? Colors.green
              : currentCostumer.balance < 0
                  ? Colors.red
                  : const Color(0xffdbdbdb),
        ),
      ],
    );
  }
}

class _LastTransactions extends StatelessWidget {
  const _LastTransactions({
    Key? key,
    required this.currentCostumer,
  }) : super(key: key);
  final Costumer currentCostumer;

  List<Widget> getLastTransactions(int itemCount, bool isSale) {
    final List<Widget> transactions = [];
    int currentCount = 0;

    for (Transaction transaction in currentCostumer.reversedTransactions) {
      if (transaction.isSale == isSale) {
        transactions.add(_TransactionTile(
          currentTransaction: transaction,
          isSale: isSale,
        ));
        currentCount++;

        if (currentCount == itemCount) break;
      }
    }

    if (currentCount == 0) {
      transactions.add(
        const CustomDivider(
          lenght: 150,
          thickness: 6,
          margin: EdgeInsets.only(top: 25),
          color: appbarColor,
        ),
      );
    }

    return transactions;
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 400,
            child: Column(
              children: [
                const Text(
                  "Sales",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ...getLastTransactions(5, true),
              ],
            ),
          ),
          const CustomDivider(
            thickness: 5,
            margin: EdgeInsets.only(
              top: 15,
              left: 25,
              right: 25,
            ),
            color: backgroundColorHeavy,
            isVertical: true,
          ),
          SizedBox(
            width: 400,
            child: Column(
              children: [
                const Text(
                  "Payments",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ...getLastTransactions(5, false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({
    Key? key,
    required Transaction currentTransaction,
    required this.isSale,
  })  : _currentTransaction = currentTransaction,
        super(key: key);

  final bool isSale;
  final Transaction _currentTransaction;
  final TextStyle tileTextStyle = const TextStyle(
    fontSize: 17,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      color: backgroundColorHeavy,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              _currentTransaction.transactionDate.substring(0, 5),
              textAlign: TextAlign.center,
              style: tileTextStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 180,
            child: Text(
              _currentTransaction.comment,
              textAlign: TextAlign.center,
              style: tileTextStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              "${isSale ? "+" : "-"}${_currentTransaction.totalPrice.toString()} TL",
              textAlign: TextAlign.center,
              style: tileTextStyle.copyWith(
                color: isSale ? Colors.green : Colors.red,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductPageButtons extends StatelessWidget {
  const _ProductPageButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CostumersData costumersData = Provider.of<CostumersData>(context, listen: false);
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(15),
      color: backgroundColorLight,
      child: SizedBox(
        width: 200,
        height: 450,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleIconButton(
              onPressed: () => navigateWithoutAnim(
                context,
                CostumerEditPage(
                  currentCostumer: costumersData.currentCostumer!,
                ),
              ),
              toolTipText: "Edit costumer",
              preferBelow: false,
              icon: Icons.edit,
            ),
            const CustomDivider(
              thickness: 2,
              lenght: 150,
              color: Colors.black26,
            ),
            CircleIconButton(
              onPressed: () => navigateWithoutAnim(
                context,
                const CostumerTransactionsPage(),
              ),
              toolTipText: "Transactions",
              preferBelow: false,
              icon: Icons.description,
            ),
            const CustomDivider(
              thickness: 2,
              lenght: 150,
              color: Colors.black26,
            ),
            CircleIconButton(
              onPressed: () async => navigateWithoutAnim(context, const CostumersPage()),
              toolTipText: "Go back",
              icon: Icons.arrow_back,
              iconSize: 30,
            ),
          ],
        ),
      ),
    );
  }
}
