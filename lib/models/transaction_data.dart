import 'dart:io';

import 'package:business_management/helpers/months.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/costumer_data.dart';
import 'package:business_management/models/transaction.dart';
import 'package:business_management/models/transaction_type.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class TransactionsData extends ChangeNotifier {
  final transactionsBox = Hive.box<Transaction>("transactionsBox");

  Map<int, List<Transaction>> transactionsByMonths = {0: [], 1: [], 2: [], 3: [], 4: [], 5: [], 6: [], 7: [], 8: [], 9: [], 10: [], 11: []};
  Map<int, double> balanceByMonths = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0, 10: 0, 11: 0};

  List<Transaction> allPaymentTransactions = [];

  double balance = 0;

  void getTransactionsList() {
    allPaymentTransactions = [];
    transactionsByMonths = {0: [], 1: [], 2: [], 3: [], 4: [], 5: [], 6: [], 7: [], 8: [], 9: [], 10: [], 11: []};

    List<Transaction> allTransactions = transactionsBox.values.toList();
    DateFormat format = DateFormat("dd/MM/yyyy");
    allTransactions.sort((a, b) => format.parse(a.transactionDate).compareTo(format.parse(b.transactionDate)));

    for (final Transaction transaction in allTransactions) {
      if (transaction.transactionType == TransactionType.costumersPayment || transaction.transactionType == TransactionType.suppliersPayment) {
        allPaymentTransactions.add(transaction);
        final int month = int.parse(transaction.transactionDate.substring(3, 5)) - 1;
        if (month < 12) {
          transactionsByMonths[month]!.add(transaction);
        }
      }
    }

    calculateBalance();
    notifyListeners();
  }

  double getMonthBalance(int i) => balanceByMonths[i] ?? 0;

  void calculateBalance() {
    balanceByMonths = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0, 10: 0, 11: 0};

    for (int i = 0; i < 12; i++) {
      double monthBalance = 0;

      for (final Transaction transaction in transactionsByMonths[i]!) {
        if (TransactionType.costumersPayment == transaction.transactionType) {
          monthBalance += transaction.totalPrice;
        } else if (TransactionType.suppliersPayment == transaction.transactionType) {
          monthBalance -= transaction.totalPrice;
        }
      }

      balanceByMonths[i] = monthBalance;
    }

    balance = 0;
    for (int i = 0; i < 12; i++) {
      balance += balanceByMonths[i]!;
    }
  }

  TransactionsData() {
    transactionsByMonths = {0: [], 1: [], 2: [], 3: [], 4: [], 5: [], 6: [], 7: [], 8: [], 9: [], 10: [], 11: []};
    allPaymentTransactions = [];

    List<Transaction> allTransactions = transactionsBox.values.toList();

    for (final Transaction transaction in allTransactions) {
      if (transaction.transactionType == TransactionType.costumersPayment || transaction.transactionType == TransactionType.suppliersPayment) {
        final int month = int.parse(transaction.transactionDate.substring(3, 5)) - 1;
        allPaymentTransactions.add(transaction);
        if (month < 12) {
          transactionsByMonths[month]!.add(transaction);
        }
      }
    }

    calculateBalance();
  }

  void deleteMonthSelectedTransactions(int month) async {
    for (final Transaction transaction in transactionsByMonths[month]!) {
      if (transaction.isSelected) {
        await transaction.delete();
      }
    }
    getTransactionsList();
  }

  void addTransactionToList(Transaction transaction) async {
    await transactionsBox.add(transaction);

    getTransactionsList();
  }

  void deleteAllSelectedTransactions() async {
    for (final Transaction transaction in allPaymentTransactions) {
      if (transaction.isSelected) {
        await transaction.delete();
      }
    }
    getTransactionsList();
  }

  void setIsSelectedOfAllMonth(bool? value, int month) {
    if (value == null) return;

    for (Transaction transaction in transactionsByMonths[month]!) {
      transaction.isSelected = value;
    }
  }

  void setIsSelectedOfAllTransactions(bool? value) {
    if (value == null) return;

    for (Transaction transaction in allPaymentTransactions) {
      transaction.isSelected = value;
    }
  }

  List<ExcelDataRow> buildTransactionDataRows(BuildContext context, List<Transaction> transactions) {
    List<ExcelDataRow> excelDataRows = transactions
        .map((transaction) => ExcelDataRow(cells: <ExcelDataCell>[
              ExcelDataCell(
                columnHeader: appLocalization(context).date,
                value: transaction.transactionDate,
              ),
              ExcelDataCell(
                columnHeader: appLocalization(context).comment,
                value: transaction.comment,
              ),
              ExcelDataCell(
                columnHeader: appLocalization(context).collections,
                value: transaction.transactionType == TransactionType.costumersPayment ? transaction.totalPrice : null,
              ),
              ExcelDataCell(
                columnHeader: appLocalization(context).payments,
                value: transaction.transactionType == TransactionType.suppliersPayment ? transaction.totalPrice : null,
              ),
              ExcelDataCell(
                columnHeader: appLocalization(context).balance,
                value: null,
              ),
            ]))
        .toList();

    return excelDataRows;
  }

  void createTransactionsTable(Worksheet sheet, Style globalStyle, Style headerStyle, BuildContext context, List<Transaction> transactions) {
    final List<ExcelDataRow> transactionsDataRows = buildTransactionDataRows(context, transactions);

    sheet.importData(transactionsDataRows, 1, 1);

    final int lastColumn = sheet.getLastColumn();
    final int lastRow = sheet.getLastRow();
    final Range range = sheet.getRangeByIndex(1, 1, lastRow, lastColumn);

    range.cellStyle = globalStyle;

    final Range rangeHeaders = sheet.getRangeByIndex(1, 1, 1, lastColumn);

    rangeHeaders.cellStyle = headerStyle;
  }

  void createVaultInformationsTable(
    Worksheet sheet,
    Style style,
    BuildContext context,
  ) {
    final List<Object> totalBalanceDataRows = [
      appLocalization(context).totalCollections,
      appLocalization(context).totalPayments,
      appLocalization(context).totalBalance,
    ];

    sheet.importList(totalBalanceDataRows, 1, 7, true);

    final Range totalBalanceRange = sheet.getRangeByName("G1:H3");
    totalBalanceRange.cellStyle = style;
  }

  void createExcelFromTransactions(BuildContext context, {int month = -1}) async {
    final String? directoryPath = await getSavePath(
        suggestedName: month >= 0 && month < 12
            ? "${months(context)[month]} ${appLocalization(context).transactions}"
            : appLocalization(context).allTransactions);
    if (directoryPath == null) return;

    final Workbook workbook = Workbook();

    final Style globalStyle = workbook.styles.add('globalStyle');
    globalStyle.hAlign = HAlignType.center;
    globalStyle.vAlign = VAlignType.center;
    globalStyle.backColor = "#D9E1F2";
    globalStyle.borders.all.lineStyle = LineStyle.thin;

    final Style headerStyle = workbook.styles.add('headerStyle');
    headerStyle.hAlign = HAlignType.center;
    headerStyle.vAlign = VAlignType.center;
    headerStyle.backColor = "#FCE4D6";
    headerStyle.borders.top.lineStyle = LineStyle.thin;
    headerStyle.borders.bottom.lineStyle = LineStyle.double;
    headerStyle.borders.right.lineStyle = LineStyle.thin;
    headerStyle.borders.left.lineStyle = LineStyle.thin;

    final Style informationStyle = workbook.styles.add('informationStyle');
    informationStyle.hAlign = HAlignType.left;
    informationStyle.vAlign = VAlignType.center;
    informationStyle.indent = 0;
    informationStyle.borders.all.lineStyle = LineStyle.thin;

    final Worksheet sheet = workbook.worksheets[0];

    List<Transaction> transactions = month >= 0 && month < 12 ? transactionsByMonths[month]! : allPaymentTransactions;

    if (allPaymentTransactions.isNotEmpty) {
      createTransactionsTable(sheet, globalStyle, headerStyle, context, transactions);
      sheet.getRangeByName('E2').setFormula('=D2-C2');
    }

    createVaultInformationsTable(sheet, informationStyle, context);

    int transactionCount = transactions.length;

    sheet.getRangeByName("C2:E${transactionCount + 1}").numberFormat = '₺#,##0.0';

    for (int i = 3, last = transactionCount + 1; i <= last; i++) {
      sheet.getRangeByName('E$i').setFormula('=E${i - 1}+D$i-C$i');
    }

    sheet.getRangeByIndex(1, 1, sheet.getLastRow(), 1).rowHeight = 22;

    sheet.getRangeByName('H1').setFormula('=SUM(C2:C${transactionCount + 1})');
    sheet.getRangeByName('H2').setFormula('=SUM(D2:D${transactionCount + 1})');
    sheet.getRangeByName('H3').setFormula('=H2-H1');
    sheet.getRangeByName("H1:H3").numberFormat = '₺#,##0.0';

    sheet.getRangeByName("A1").columnWidth = 12.14;
    sheet.getRangeByName("B1").columnWidth = 50;
    sheet.getRangeByName("C1").columnWidth = 12.86;
    sheet.getRangeByName("D1").columnWidth = 12.86;
    sheet.getRangeByName("E1").columnWidth = 12.86;
    sheet.getRangeByName('G1').columnWidth = 15;
    sheet.getRangeByName('H1').columnWidth = 13;

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    File('$directoryPath.xlsx').writeAsBytes(bytes);
  }
}
