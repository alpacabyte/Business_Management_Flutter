import 'package:business_management/functions/navigate_without_anim.dart';
import 'package:business_management/functions/size_config.dart';
import 'package:business_management/helpers/colors.dart';
import 'package:business_management/helpers/months.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/transaction_data.dart';
import 'package:business_management/screens/home/home_page.dart';
import 'package:business_management/screens/vault/all_transactions.page.dart';
import 'package:business_management/screens/vault/transactions_by_month.dart';
import 'package:business_management/widgets/circle_icon_button.dart';
import 'package:business_management/widgets/custom_divider.dart';
import 'package:business_management/widgets/left_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VaultChoosePage extends StatefulWidget {
  const VaultChoosePage({Key? key}) : super(key: key);

  @override
  State<VaultChoosePage> createState() => _VaultChoosePageState();
}

class _VaultChoosePageState extends State<VaultChoosePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<TransactionsData>(context, listen: false).getTransactionsList());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Scaffold(
      body: TitleBarWithLeftNav(
        page: Pages.vault,
        children: [
          Spacer(),
          _Months(),
          _VaultButtons(),
          Spacer(),
        ],
      ),
    );
  }
}

class _Months extends StatelessWidget {
  const _Months({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TransactionsData transactionsData = Provider.of<TransactionsData>(context);
    SizeConfig().init(context);
    return Container(
      width: 900,
      height: SizeConfig.safeBlockVertical * 85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: backgroundColorLight,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(40),
      child: GridView(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 55,
          crossAxisSpacing: 20,
        ),
        children: [
          _MonthCard(month: 0, balanceOfMonth: transactionsData.getMonthBalance(0)),
          _MonthCard(month: 1, balanceOfMonth: transactionsData.getMonthBalance(1)),
          _MonthCard(month: 2, balanceOfMonth: transactionsData.getMonthBalance(2)),
          _MonthCard(month: 3, balanceOfMonth: transactionsData.getMonthBalance(3)),
          _MonthCard(month: 4, balanceOfMonth: transactionsData.getMonthBalance(4)),
          _MonthCard(month: 5, balanceOfMonth: transactionsData.getMonthBalance(5)),
          _MonthCard(month: 6, balanceOfMonth: transactionsData.getMonthBalance(6)),
          _MonthCard(month: 7, balanceOfMonth: transactionsData.getMonthBalance(7)),
          _MonthCard(month: 8, balanceOfMonth: transactionsData.getMonthBalance(8)),
          _MonthCard(month: 9, balanceOfMonth: transactionsData.getMonthBalance(9)),
          _MonthCard(month: 10, balanceOfMonth: transactionsData.getMonthBalance(10)),
          _MonthCard(month: 11, balanceOfMonth: transactionsData.getMonthBalance(11)),
        ],
      ),
    );
  }
}

class _MonthCard extends StatefulWidget {
  const _MonthCard({
    Key? key,
    required this.month,
    required this.balanceOfMonth,
  }) : super(key: key);

  final int month;
  final double balanceOfMonth;

  @override
  State<_MonthCard> createState() => _MonthCardState();
}

class _MonthCardState extends State<_MonthCard> {
  Color cardColor = backgroundColorHeavy;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateWithoutAnim(context, TransactionsByMonthPage(month: widget.month)),
      child: MouseRegion(
        onEnter: (e) => setState(() => cardColor = const Color(0xff3c3c47)),
        onExit: (e) => setState(() => cardColor = backgroundColorHeavy),
        cursor: SystemMouseCursors.click,
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: cardColor,
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  months(context)[widget.month],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                RichText(
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${months(context)[widget.month]} ${appLocalization(context).balance}:\n",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      TextSpan(
                        text: "${widget.balanceOfMonth} TL",
                        style: TextStyle(
                          fontSize: 20,
                          color: widget.balanceOfMonth > 0
                              ? Colors.green
                              : widget.balanceOfMonth < 0
                                  ? Colors.red
                                  : const Color(0xffdbdbdb),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class _VaultButtons extends StatelessWidget {
  const _VaultButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TransactionsData transactionsData = Provider.of<TransactionsData>(context);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
        color: backgroundColorLight,
      ),
      width: 355,
      height: 450,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RichText(
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "${appLocalization(context).totalBalance}:\n",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                TextSpan(
                    text: "${transactionsData.balance} TL",
                    style: TextStyle(
                      fontSize: 20,
                      color: transactionsData.balance > 0
                          ? Colors.green
                          : transactionsData.balance < 0
                              ? Colors.red
                              : const Color(0xffdbdbdb),
                    )),
              ],
            ),
          ),
          const _AllTransactionsCard(),
        ],
      ),
    );
  }
}

class _AllTransactionsCard extends StatefulWidget {
  const _AllTransactionsCard({Key? key}) : super(key: key);

  @override
  State<_AllTransactionsCard> createState() => _AllTransactionsCardState();
}

class _AllTransactionsCardState extends State<_AllTransactionsCard> {
  Color cardColor = backgroundColorHeavy;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateWithoutAnim(context, const AllTransactionsPage()),
      child: MouseRegion(
        onEnter: (e) => setState(() => cardColor = const Color(0xff3c3c47)),
        onExit: (e) => setState(() => cardColor = backgroundColorHeavy),
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 195,
          height: 195,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: cardColor,
          ),
          alignment: Alignment.center,
          child: Text(
            appLocalization(context).allTransactions,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
