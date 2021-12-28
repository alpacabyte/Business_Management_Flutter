import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/helpers/colors.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/supplier_data.dart';
import 'package:business_management/models/transaction.dart';
import 'package:business_management/models/transaction_data.dart';
import 'package:business_management/models/transaction_type.dart';
import 'package:business_management/screens/supplier/supplier_page.dart';
import 'package:business_management/screens/transaction/supplier_transaction/supplier_choose_transaction_type_page.dart';
import 'package:business_management/screens/transaction/vault_transaction/vault_add_in_page.dart';
import 'package:business_management/screens/transaction/vault_transaction/vault_choose_transaction_type.dart';
import 'package:business_management/screens/vault/vault_choose_page.dart';
import 'package:business_management/widgets/circle_icon_button.dart';
import 'package:business_management/widgets/custom_divider.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:business_management/widgets/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllTransactionsPage extends StatelessWidget {
  const AllTransactionsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Scaffold(
      body: TitleBarWithLeftNav(
        page: Pages.vault,
        children: [
          Spacer(),
          _Transactions(),
          Spacer(),
          _TransactionsButtons(),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}

class _Transactions extends StatefulWidget {
  const _Transactions({
    Key? key,
  }) : super(key: key);

  @override
  State<_Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<_Transactions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1000,
      height: SizeConfig.safeBlockVertical * 85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: backgroundColorLight,
      ),
      child: Consumer<TransactionsData>(builder: (context, transactionsData, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            _HeaderTile(
              onChanged: (value) => setState(() => transactionsData.setIsSelectedOfAllTransactions(value)),
              transactionsData: transactionsData,
            ),
            Expanded(
              child: _TransactionsListView(
                transactionsData: transactionsData,
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      }),
    );
  }
}

class _TransactionsListView extends StatelessWidget {
  const _TransactionsListView({
    Key? key,
    required this.transactionsData,
  }) : super(key: key);

  final TransactionsData transactionsData;

  @override
  Widget build(BuildContext context) {
    List<Transaction> transactions = transactionsData.allPaymentTransactions;
    return SizedBox(
      width: 850,
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 10),
        itemBuilder: (context, index) => _TransactionTile(
          currentTransaction: transactions[index],
        ),
        itemCount: transactions.length,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          height: 10,
        ),
      ),
    );
  }
}

class _HeaderTile extends StatefulWidget {
  const _HeaderTile({
    Key? key,
    required this.onChanged,
    required this.transactionsData,
  }) : super(key: key);

  final void Function(bool?) onChanged;
  final TransactionsData transactionsData;

  @override
  State<_HeaderTile> createState() => _HeaderTileState();
}

class _HeaderTileState extends State<_HeaderTile> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isSelected = !isSelected;
        widget.onChanged(isSelected);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Column(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: SizedBox(
                child: Text(
                  appLocalization(context).allTransactions,
                  textAlign: TextAlign.center,
                  style: tileTextStyle,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: RichText(
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${appLocalization(context).totalBalance}:   ",
                      style: tileTextStyle,
                    ),
                    TextSpan(
                        text: "${widget.transactionsData.balance} TL",
                        style: tileTextStyle.copyWith(
                          color: widget.transactionsData.balance > 0
                              ? Colors.green
                              : widget.transactionsData.balance < 0
                                  ? Colors.red
                                  : const Color(0xffdbdbdb),
                        )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Material(
                color: appbarColor,
                elevation: 5,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  width: 850,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                            ),
                            Spacer(),
                            Text(
                              appLocalization(context).transactionDate,
                              textAlign: TextAlign.center,
                              style: tileTextStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: Text(
                          appLocalization(context).comment,
                          textAlign: TextAlign.center,
                          style: tileTextStyle,
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: Text(
                          appLocalization(context).amount,
                          textAlign: TextAlign.center,
                          style: tileTextStyle,
                        ),
                      ),
                      Container(
                        width: 17.5,
                        height: 17.5,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white.withOpacity(0.7) : null,
                          border: isSelected
                              ? null
                              : Border.all(
                                  color: Colors.white.withOpacity(0.7),
                                  width: 2,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatefulWidget {
  const _TransactionTile({
    Key? key,
    required Transaction currentTransaction,
  })  : _currentTransaction = currentTransaction,
        super(key: key);

  final Transaction _currentTransaction;

  @override
  State<_TransactionTile> createState() => _TransactionTileState();
}

class _TransactionTileState extends State<_TransactionTile> {
  final Color normalColor = backgroundColorHeavy;
  final Color mouseOverColor = const Color(0xff3c3c47);
  bool isEnter = false;
  @override
  void initState() {
    widget._currentTransaction.isSelected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isIn = widget._currentTransaction.transactionType == TransactionType.costumersPayment;
    final bool isSelected = widget._currentTransaction.isSelected;
    final String toolTipMessage = widget._currentTransaction.transactionType == TransactionType.costumersPayment
        ? appLocalization(context).collection
        : appLocalization(context).payment;
    return GestureDetector(
      onTap: () => setState(() => widget._currentTransaction.isSelected = !isSelected),
      child: MouseRegion(
        onEnter: _mouseEntered,
        onExit: _mouseExited,
        cursor: SystemMouseCursors.click,
        child: Material(
          color: !isEnter ? normalColor : mouseOverColor,
          elevation: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 200,
                  child: Row(
                    children: [
                      Tooltip(
                        triggerMode: TooltipTriggerMode.tap,
                        verticalOffset: 30,
                        preferBelow: false,
                        message: toolTipMessage,
                        padding: const EdgeInsets.all(5),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                        child: const SizedBox(
                          width: 20,
                          height: 20,
                          child: Icon(
                            Icons.visibility_outlined,
                            size: 20,
                            color: Color(0xffa81633),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        widget._currentTransaction.transactionDate,
                        textAlign: TextAlign.center,
                        style: tileTextStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: Text(
                    widget._currentTransaction.comment,
                    textAlign: TextAlign.center,
                    style: tileTextStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Text(
                    "${isIn ? "+" : "-"}${widget._currentTransaction.totalPrice.toString()} TL",
                    textAlign: TextAlign.center,
                    style: tileTextStyle.copyWith(
                      color: isIn ? Colors.green : Colors.red,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: 17.5,
                  height: 17.5,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white.withOpacity(0.7) : null,
                    border: isSelected
                        ? null
                        : Border.all(
                            color: Colors.white.withOpacity(0.7),
                            width: 2,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _mouseEntered(PointerEvent details) {
    setState(() {
      isEnter = true;
    });
  }

  void _mouseExited(PointerEvent details) {
    setState(() {
      isEnter = false;
    });
  }
}

class _TransactionsButtons extends StatelessWidget {
  const _TransactionsButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              onPressed: () => navigateWithoutAnim(context, const VaultChooseTransactionTypePage()),
              toolTipText: appLocalization(context).addATransactionToList,
              icon: Icons.add,
              preferBelow: false,
              iconSize: 40,
            ),
            const CustomDivider(
              lenght: 150,
              thickness: 2,
              color: Colors.black26,
            ),
            CircleIconButton(
              onPressed: () => Provider.of<TransactionsData>(context, listen: false).deleteAllSelectedTransactions(),
              toolTipText: appLocalization(context).deleteSelectedTransactionsFromList,
              icon: Icons.delete,
              iconSize: 30,
            ),
            const CustomDivider(
              lenght: 150,
              thickness: 2,
              color: Colors.black26,
            ),
            CircleIconButton(
              onPressed: () async => navigateWithoutAnim(context, const VaultChoosePage()),
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