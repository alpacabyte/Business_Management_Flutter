import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/helpers/colors.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/supplier.dart';
import 'package:business_management/models/supplier_data.dart';
import 'package:business_management/models/transaction.dart';
import 'package:business_management/models/transaction_type.dart';
import 'package:business_management/screens/supplier/supplier_edit_page.dart';
import 'package:business_management/screens/supplier/suppliers_page.dart';
import 'package:business_management/screens/transaction/supplier_transaction/supplier_transactions_page.dart';
import 'package:business_management/widgets/circle_icon_button.dart';
import 'package:business_management/widgets/custom_divider.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:business_management/widgets/property_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupplierPage extends StatelessWidget {
  const SupplierPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Consumer<SuppliersData>(
        builder: (context, suppliersData, child) {
          Supplier currentSupplier = suppliersData.currentSupplier!;
          return TitleBarWithLeftNav(
            page: Pages.suppliers,
            children: [
              const Spacer(),
              _SupplierProperties(currentSupplier: currentSupplier),
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

class _SupplierProperties extends StatelessWidget {
  const _SupplierProperties({
    Key? key,
    required this.currentSupplier,
  }) : super(key: key);

  final Supplier currentSupplier;

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
                      text: currentSupplier.corporateTitle,
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
                    _Properties(currentSupplier: currentSupplier),
                    const SizedBox(height: 25),
                    Align(
                      alignment: const Alignment(0.75, 0),
                      child: Text(
                        "${appLocalization(context).supplierNo}: ${currentSupplier.supplierIndex}",
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
                    Text(
                      appLocalization(context).lastTransactions,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _LastTransactions(currentSupplier: currentSupplier),
                  ],
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0.98, -0.98),
              child: CircleIconButton(
                onPressed: () => Provider.of<SuppliersData>(context, listen: false).createExcelFromThisSupplier(context),
                toolTipText: appLocalization(context).createExcelFromThisSupplier,
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
    required this.currentSupplier,
  }) : super(key: key);

  final Supplier currentSupplier;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 150,
      runSpacing: 45,
      children: [
        PropertyText(
          title: appLocalization(context).eMail,
          text: currentSupplier.email,
        ),
        PropertyText(
          title: appLocalization(context).phoneNumber,
          text: currentSupplier.phoneNumber,
        ),
        PropertyText(
          title: appLocalization(context).taxAdministration,
          text: currentSupplier.taxAdministration,
        ),
        PropertyText(
          title: appLocalization(context).taxNumber,
          text: currentSupplier.taxNumber,
        ),
        PropertyText(
          title: appLocalization(context).created,
          text: currentSupplier.creationDate,
        ),
        PropertyText(
          title: appLocalization(context).lastModified,
          text: currentSupplier.lastModifiedDate ?? "-",
        ),
        PropertyText(
          title: appLocalization(context).address,
          text: currentSupplier.address,
        ),
        PropertyText(
          title: appLocalization(context).totalBalance,
          text: "${currentSupplier.balance.toString()} TL",
          textColor: currentSupplier.balance > 0
              ? Colors.green
              : currentSupplier.balance < 0
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
    required this.currentSupplier,
  }) : super(key: key);
  final Supplier currentSupplier;

  List<Widget> getLastTransactions(int itemCount, TransactionType transactionType) {
    final List<Widget> transactions = [];
    int currentCount = 0;

    for (Transaction transaction in currentSupplier.reversedTransactions) {
      if (transaction.transactionType == transactionType) {
        transactions.add(
          _TransactionTile(
            currentTransaction: transaction,
            transactionType: transactionType,
          ),
        );
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
                Text(
                  appLocalization(context).purchases,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ...getLastTransactions(5, TransactionType.suppliersPurchase),
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
                Text(
                  appLocalization(context).payments,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ...getLastTransactions(5, TransactionType.suppliersPayment),
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
    required this.transactionType,
  })  : _currentTransaction = currentTransaction,
        super(key: key);

  final TransactionType transactionType;
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
              "${transactionType == TransactionType.suppliersPayment ? "+" : "-"}${_currentTransaction.totalPrice.toString()} TL",
              textAlign: TextAlign.center,
              style: tileTextStyle.copyWith(
                color: transactionType == TransactionType.suppliersPayment ? Colors.green : Colors.red,
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
    SuppliersData suppliersData = Provider.of<SuppliersData>(context, listen: false);
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
                SupplierEditPage(
                  currentSupplier: suppliersData.currentSupplier!,
                ),
              ),
              toolTipText: appLocalization(context).editSupplier,
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
                const SupplierTransactionsPage(),
              ),
              toolTipText: appLocalization(context).transactions,
              preferBelow: false,
              icon: Icons.description,
            ),
            const CustomDivider(
              thickness: 2,
              lenght: 150,
              color: Colors.black26,
            ),
            CircleIconButton(
              onPressed: () async => navigateWithoutAnim(context, const SuppliersPage()),
              toolTipText: appLocalization(context).goBack,
              icon: Icons.arrow_back,
              iconSize: 30,
            ),
          ],
        ),
      ),
    );
  }
}
