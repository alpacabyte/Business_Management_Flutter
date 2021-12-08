import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/costumer_data.dart';
import 'package:business_management/models/transaction.dart';
import 'package:business_management/screens/costumer/costumers_page.dart';
import 'package:business_management/screens/transaction/choose_transaction_type_page.dart';
import 'package:business_management/screens/transaction/costumer_transactions_page.dart';
import 'package:business_management/screens/transaction/payment_transaction_form.dart';
import 'package:business_management/widgets/circle_icon_button.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PaymentTransactionAddPage extends StatefulWidget {
  const PaymentTransactionAddPage({Key? key}) : super(key: key);

  @override
  State<PaymentTransactionAddPage> createState() =>
      _PaymentTransactionAddPageState();
}

class _PaymentTransactionAddPageState extends State<PaymentTransactionAddPage> {
  // #region Controllers
  final TextEditingController _commentController =
      TextEditingController(text: "Payment");
  final TextEditingController _amountController =
      TextEditingController(text: "0");
  final TextEditingController _transactionDateController =
      TextEditingController(
          text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
// #endregion

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: TitleBarWithLeftNav(
        page: Pages.costumers,
        children: [
          const Spacer(),
          PaymentTransactionForm(
            commentController: _commentController,
            amountController: _amountController,
            transactionDateController: _transactionDateController,
          ),
          const Spacer(),
          _AddTransactionPageButtons(addTransaction: addTransaction),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  void addTransaction() {
    final String comment =
        _commentController.text != "" ? _commentController.text : "null";
    final double amount =
        _amountController.text != "" ? double.parse(_amountController.text) : 0;
    final String transactionDate = _transactionDateController.text != ""
        ? _transactionDateController.text
        : "00/00/0000";

    Provider.of<CostumersData>(context, listen: false)
        .addTransactionToCurrentCostumer(
      Transaction(
        comment: comment,
        transactionDate: transactionDate,
        unitPrice: amount,
        isSale: false,
      ),
    );
  }
}

class _AddTransactionPageButtons extends StatelessWidget {
  const _AddTransactionPageButtons({
    Key? key,
    required Function addTransaction,
  })  : _addTransaction = addTransaction,
        super(key: key);

  final Function _addTransaction;

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
            CircleIconButton(
              onPressed: () async {
                await _addTransaction();
                navigateWithoutAnim(context, const PaymentTransactionAddPage());
              },
              toolTipText: "Save the transaction and create another",
              preferBelow: false,
              icon: Icons.edit,
            ),
            Container(
              height: 2,
              width: 150,
              color: Colors.black26,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleIconButton(
                  onPressed: () async {
                    await _addTransaction();
                    navigateWithoutAnim(
                        context, const CostumerTransactionsPage());
                  },
                  toolTipText: "Save the transaction and go to list",
                  icon: Icons.done,
                ),
                Container(
                  height: 75,
                  width: 2,
                  color: Colors.black26,
                ),
                CircleIconButton(
                  onPressed: () => navigateWithoutAnim(
                      context, const ChooseTransactionTypePage()),
                  toolTipText: 'Cancel and go back',
                  icon: Icons.close,
                  iconSize: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
