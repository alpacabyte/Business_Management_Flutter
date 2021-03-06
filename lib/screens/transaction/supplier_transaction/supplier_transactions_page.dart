import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/helpers/colors.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/supplier.dart';
import 'package:business_management/models/supplier_data.dart';
import 'package:business_management/models/transaction.dart';
import 'package:business_management/models/transaction_type.dart';
import 'package:business_management/screens/supplier/supplier_page.dart';
import 'package:business_management/screens/transaction/supplier_transaction/supplier_choose_transaction_type_page.dart';
import 'package:business_management/widgets/circle_icon_button.dart';
import 'package:business_management/widgets/custom_divider.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:business_management/widgets/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupplierTransactionsPage extends StatelessWidget {
  const SupplierTransactionsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Scaffold(
      body: TitleBarWithLeftNav(
        page: Pages.suppliers,
        children: [
          Spacer(),
          _Transactions(),
          Spacer(),
          _SupplierButtons(),
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
      child: Consumer<SuppliersData>(builder: (context, suppliersData, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            _HeaderTile(
              currentSupplier: suppliersData.currentSupplier!,
              onChanged: (value) => setState(() => suppliersData.setIsSelectedOfAllTransactions(value)),
            ),
            Expanded(
              child: _TransactionsListView(
                currentSupplier: suppliersData.currentSupplier!,
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
    required this.currentSupplier,
  }) : super(key: key);

  final Supplier currentSupplier;

  @override
  Widget build(BuildContext context) {
    List<Transaction> currentSuppliersTransactions = currentSupplier.transactions;
    return SizedBox(
      width: 850,
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 10),
        itemBuilder: (context, index) => _TransactionTile(
          currentTransaction: currentSuppliersTransactions[index],
        ),
        itemCount: currentSuppliersTransactions.length,
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
    required this.currentSupplier,
    required this.onChanged,
  }) : super(key: key);

  final Supplier currentSupplier;
  final void Function(bool?) onChanged;

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
                  "${widget.currentSupplier.corporateTitle}'${appLocalization(context).sTransaction}",
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
                        text: "${widget.currentSupplier.balance.toString()} TL",
                        style: tileTextStyle.copyWith(
                          color: widget.currentSupplier.balance > 0
                              ? Colors.green
                              : widget.currentSupplier.balance < 0
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
                            const Spacer(),
                            Text(
                              appLocalization(context).transactionDate,
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
    final bool isSelected = widget._currentTransaction.isSelected;
    final String toolTipMessage = widget._currentTransaction.transactionType == TransactionType.suppliersPurchase
        ? "${widget._currentTransaction.comment}\n-${appLocalization(context).quantity}: ${widget._currentTransaction.quantity}\n-${appLocalization(context).unitPrice}: ${widget._currentTransaction.unitPrice} TL\n-${appLocalization(context).totalPrice}: ${widget._currentTransaction.totalPrice} TL"
        : widget._currentTransaction.comment;
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
                    "${widget._currentTransaction.transactionType == TransactionType.suppliersPayment ? "+" : "-"}${widget._currentTransaction.totalPrice.toString()} TL",
                    textAlign: TextAlign.center,
                    style: tileTextStyle.copyWith(
                      color: widget._currentTransaction.transactionType == TransactionType.suppliersPayment ? Colors.green : Colors.red,
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

class _SupplierButtons extends StatelessWidget {
  const _SupplierButtons({
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
              onPressed: () => navigateWithoutAnim(context, const SupplierChooseTransactionTypePage()),
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
              onPressed: () => Provider.of<SuppliersData>(context, listen: false).deleteSelectedTransactionsFromCurrentSupplier(),
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
              onPressed: () async => navigateWithoutAnim(context, const SupplierPage()),
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
