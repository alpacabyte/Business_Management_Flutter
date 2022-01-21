import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/helpers/colors.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/costumer_data.dart';
import 'package:business_management/models/transaction.dart';
import 'package:business_management/models/transaction_type.dart';
import 'package:business_management/screens/transaction/costumer_transaction/costumer_choose_transaction_type_page.dart';
import 'package:business_management/screens/transaction/costumer_transaction/costumer_transactions_page.dart';
import 'package:business_management/widgets/circle_icon_button.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:business_management/widgets/sale_transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CostumerSaleTransactionAddPage extends StatefulWidget {
  const CostumerSaleTransactionAddPage({Key? key}) : super(key: key);

  @override
  State<CostumerSaleTransactionAddPage> createState() => _CostumerSaleTransactionAddPageState();
}

class _CostumerSaleTransactionAddPageState extends State<CostumerSaleTransactionAddPage> {
  // #region Controllers
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(text: "0");
  final TextEditingController _unitPriceController = TextEditingController(text: "0");
  final TextEditingController _transactionDateController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now()));

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timestamp) {
      _commentController.text = "${Provider.of<CostumersData>(context, listen: false).currentCostumer!.corporateTitle} Satış";
    });
  }
// #endregion

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: TitleBarWithLeftNav(
        page: Pages.costumers,
        children: [
          const Spacer(),
          SaleTransactionForm(
            commentController: _commentController,
            quantityController: _quantityController,
            unitPriceController: _unitPriceController,
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
    final String comment = _commentController.text != "" ? _commentController.text : "-";
    final int quantity = _quantityController.text != "" ? int.parse(_quantityController.text) : 0;
    final double unitPrice = _unitPriceController.text != "" ? double.parse(_unitPriceController.text) : 0;
    final String transactionDate = _transactionDateController.text != "" ? _transactionDateController.text : "00/00/0000";

    Provider.of<CostumersData>(context, listen: false).addTransactionToCurrentCostumer(
      Transaction(
        comment: comment,
        transactionDate: transactionDate,
        unitPrice: unitPrice,
        transactionType: TransactionType.costumersSale,
        quantity: quantity,
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
                navigateWithoutAnim(context, const CostumerSaleTransactionAddPage());
              },
              toolTipText: appLocalization(context).saveTheTransactionAndCreateAnother,
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
                    navigateWithoutAnim(context, const CostumerTransactionsPage());
                  },
                  toolTipText: appLocalization(context).saveTheTransactionAndGoToList,
                  icon: Icons.done,
                ),
                Container(
                  height: 75,
                  width: 2,
                  color: Colors.black26,
                ),
                CircleIconButton(
                  onPressed: () => navigateWithoutAnim(context, const CostumerChooseTransactionTypePage()),
                  toolTipText: appLocalization(context).cancelAndGoBack,
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
