import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/helpers/colors.dart';
import 'package:business_management/main.dart';
import 'package:business_management/screens/transaction/costumer_transaction/costumer_add_payment_transaction.page.dart';
import 'package:business_management/screens/transaction/costumer_transaction/costumer_add_sale_transaction_page.dart';
import 'package:business_management/screens/transaction/costumer_transaction/costumer_transactions_page.dart';
import 'package:business_management/screens/transaction/vault_transaction/vault_add_in_page.dart';
import 'package:business_management/screens/transaction/vault_transaction/vault_add_out_page.dart';
import 'package:business_management/screens/vault/vault_choose_page.dart';
import 'package:business_management/widgets/circle_icon_button.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:flutter/material.dart';

class VaultChooseTransactionTypePage extends StatefulWidget {
  const VaultChooseTransactionTypePage({Key? key}) : super(key: key);

  @override
  State<VaultChooseTransactionTypePage> createState() => _VaultChooseTransactionTypePageState();
}

class _VaultChooseTransactionTypePageState extends State<VaultChooseTransactionTypePage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Scaffold(
      body: TitleBarWithLeftNav(
        page: Pages.vault,
        children: [
          Spacer(),
          _TypeButtons(),
          Spacer(),
          _ChooseTransactionTypePageButtons(),
          SizedBox(width: 20),
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
            title: appLocalization(context).collectionTransaction,
            onTap: () => navigateWithoutAnim(context, const VaultInTransactionAddPage()),
          ),
          const SizedBox(height: 100),
          _TypeButton(
            title: appLocalization(context).paymentTransaction,
            onTap: () => navigateWithoutAnim(context, const VaultOutTransactionAddPage()),
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
  }) : super(key: key);

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
            navigateWithoutAnim(context, const VaultChoosePage());
          },
          toolTipText: appLocalization(context).goBack,
          preferBelow: false,
          icon: Icons.arrow_back,
        ),
      ),
    );
  }
}
