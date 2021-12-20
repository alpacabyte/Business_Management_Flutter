import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/main.dart';
import 'package:business_management/screens/transaction/costumer_transaction/costumer_add_payment_transaction.page.dart';
import 'package:business_management/screens/transaction/costumer_transaction/costumer_add_sale_transaction_page.dart';
import 'package:business_management/screens/transaction/costumer_transaction/costumer_transactions_page.dart';
import 'package:business_management/widgets/circle_icon_button.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:flutter/material.dart';

class CostumerChooseTransactionTypePage extends StatefulWidget {
  const CostumerChooseTransactionTypePage({Key? key}) : super(key: key);

  @override
  State<CostumerChooseTransactionTypePage> createState() => _CostumerChooseTransactionTypePageState();
}

class _CostumerChooseTransactionTypePageState extends State<CostumerChooseTransactionTypePage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: TitleBarWithLeftNav(
        page: Pages.costumers,
        children: [
          const Spacer(),
          const _TypeButtons(),
          const Spacer(),
          _ChooseTransactionTypePageButtons(addTransaction: () {}),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}

class _TypeButtons extends StatelessWidget {
  const _TypeButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: 1000,
      height: SizeConfig.safeBlockVertical * 85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: backgroundColorLight,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _TypeButton(
            title: "Sale Transaction",
            onTap: () => navigateWithoutAnim(context, const CostumerSaleTransactionAddPage()),
          ),
          const SizedBox(height: 100),
          _TypeButton(
            title: "Payment Transaction",
            onTap: () => navigateWithoutAnim(context, const CostumerPaymentTransactionAddPage()),
          ),
        ],
      ),
    );
  }
}

class _TypeButton extends StatefulWidget {
  const _TypeButton({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final Function onTap;

  @override
  State<_TypeButton> createState() => _TypeButtonState();
}

class _TypeButtonState extends State<_TypeButton> {
  final Color normalColor = backgroundColorHeavy;
  final Color mouseOverColor = const Color(0xff3c3c47);
  bool isEnter = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => widget.onTap(),
      child: MouseRegion(
        onEnter: _mouseEntered,
        onExit: _mouseExited,
        cursor: SystemMouseCursors.click,
        child: Material(
          color: !isEnter ? normalColor : mouseOverColor,
          elevation: 20,
          borderRadius: BorderRadius.circular(15),
          child: SizedBox(
            width: 400,
            height: 150,
            child: Center(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
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

class _ChooseTransactionTypePageButtons extends StatelessWidget {
  const _ChooseTransactionTypePageButtons({
    Key? key,
    required Function addTransaction,
  })  : _addCostumer = addTransaction,
        super(key: key);

  final Function _addCostumer;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(15),
      color: backgroundColorLight,
      child: SizedBox(
        width: 200,
        height: 300,
        child: CircleIconButton(
          onPressed: () async {
            await _addCostumer();
            navigateWithoutAnim(context, const CostumerTransactionsPage());
          },
          toolTipText: "Go Back",
          preferBelow: false,
          icon: Icons.arrow_back,
        ),
      ),
    );
  }
}
