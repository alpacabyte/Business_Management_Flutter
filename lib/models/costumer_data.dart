import 'dart:io';

import 'package:business_management/models/costumer.dart';
import 'package:business_management/models/transaction.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class CostumersData extends ChangeNotifier {
  final Box<Costumer> _costumerBox = Hive.box<Costumer>("costumersBox");

  List<Costumer> _costumers = [];

  Costumer? _currentCostumer;

  CostumersData() {
    _costumers = _costumerBox.values.toList();
  }

  void getCostumersList() async {
    _costumers = _costumerBox.values.toList();

    notifyListeners();
  }

  Costumer getCostumer(int key) => _costumers[key];

  int get costumerCount => _costumers.length;

  Future<void> deleteCostumer(key) async {
    await _costumerBox.delete(key);

    _costumers = _costumerBox.values.toList();

    notifyListeners();
  }

  Future<void> deleteAllCostumers() async {
    await _costumerBox.clear();

    _costumers = _costumerBox.values.toList();

    notifyListeners();
  }

  Future<void> addCostumer({
    required String corporateTitle,
    required String taxNumber,
    required String taxAdministration,
    required String address,
    required String phoneNumber,
    required String email,
  }) async {
    int costumerIndex = 0;

    for (final Costumer costumer in _costumers) {
      if (costumer.costumerIndex > costumerIndex) {
        costumerIndex = costumer.costumerIndex;
      }
    }

    costumerIndex++;

    await _costumerBox.put(
      _costumerBox.length,
      Costumer(
        costumerIndex: _costumerBox.length,
        corporateTitle: corporateTitle,
        taxNumber: taxNumber,
        taxAdministration: taxAdministration,
        address: address,
        phoneNumber: phoneNumber,
        email: email,
        creationDate: DateFormat('yMd').format(DateTime.now()),
        transactions: [],
      ),
    );

    _costumers = _costumerBox.values.toList();

    notifyListeners();
  }

  void setIsSelectedOfAllCostumers(bool? value) {
    if (value == null) return;

    for (Costumer costumer in _costumers) {
      costumer.isSelected = value;
    }
  }

  void setIsSelectedOfAllTransactions(bool? value) {
    if (value == null) return;

    for (Transaction transaction in currentCostumer!.transactions) {
      transaction.isSelected = value;
    }
  }

  Future<void> deleteSelectedCostumers() async {
    for (Costumer costumer in _costumers) {
      if (costumer.isSelected) {
        _costumerBox.delete(costumer.costumerIndex);
      }
    }

    _costumers = _costumerBox.values.toList();

    notifyListeners();
  }

  Future<void> addTransactionToCurrentCostumer(Transaction newTransaction) async {
    await currentCostumer!.addTransaction(newTransaction);
    notifyListeners();
  }

  Future<void> editCostumer({
    required String corporateTitle,
    required String taxNumber,
    required String taxAdministration,
    required String address,
    required String phoneNumber,
    required String email,
    required int costumerIndex,
    required String creationDate,
    required List<Transaction> transactions,
  }) async {
    await _costumerBox.put(
      costumerIndex,
      Costumer(
        costumerIndex: costumerIndex,
        corporateTitle: corporateTitle,
        taxNumber: taxNumber,
        taxAdministration: taxAdministration,
        address: address,
        phoneNumber: phoneNumber,
        email: email,
        lastModifiedDate: DateFormat('yMd').format(DateTime.now()),
        creationDate: creationDate,
        transactions: transactions,
      ),
    );

    _currentCostumer = _costumerBox.get(costumerIndex);

    _costumers = _costumerBox.values.toList();

    notifyListeners();
  }

  Future<void> deleteTransactionFromCurrentCostumer(int index) async {
    await currentCostumer!.deleteTransaction(index);
    notifyListeners();
  }

  Future<void> deleteSelectedTransactionsFromCurrentCostumer() async {
    await currentCostumer!.deleteSelectedTransactions();
    notifyListeners();
  }

  Costumer? get currentCostumer => _currentCostumer;

  void setCurrentCostumer(key) async {
    _currentCostumer = _costumerBox.get(key);

    notifyListeners();
  }

  List<ExcelDataRow> buildTransactionDataRows(Costumer costumer) {
    List<ExcelDataRow> excelDataRows = costumer.transactions
        .map((transaction) => ExcelDataRow(cells: <ExcelDataCell>[
              ExcelDataCell(
                columnHeader: 'Date',
                value: transaction.transactionDate,
              ),
              ExcelDataCell(
                columnHeader: 'Comment',
                value: transaction.comment,
              ),
              ExcelDataCell(
                columnHeader: 'Sale',
                value: transaction.isSale ? transaction.totalPrice : null,
              ),
              ExcelDataCell(
                columnHeader: 'Payment',
                value: !transaction.isSale ? transaction.totalPrice : null,
              ),
              const ExcelDataCell(
                columnHeader: 'Balance',
                value: null,
              ),
            ]))
        .toList();

    return excelDataRows;
  }

  List<Object> buildCostumerInformationDataRows(Costumer costumer) {
    final List<Object> list = [
      costumer.corporateTitle,
      costumer.taxNumber,
      costumer.taxAdministration,
      costumer.address,
      costumer.phoneNumber,
      costumer.email,
    ];

    return list;
  }

  void createTransactionsTable(
    Worksheet sheet,
    Style globalStyle,
    Style headerStyle,
    Costumer costumer,
  ) {
    final List<ExcelDataRow> transactionsDataRows = buildTransactionDataRows(costumer);

    sheet.importData(transactionsDataRows, 1, 1);

    final int lastColumn = sheet.getLastColumn();
    final int lastRow = sheet.getLastRow();
    final Range range = sheet.getRangeByIndex(1, 1, lastRow, lastColumn);

    range.cellStyle = globalStyle;

    final Range rangeHeaders = sheet.getRangeByIndex(1, 1, 1, lastColumn);

    rangeHeaders.cellStyle = headerStyle;

    sheet.getRangeByName("A1").columnWidth = 12.14;
    sheet.getRangeByName("B1").columnWidth = 50;
    sheet.getRangeByName("C1").columnWidth = 12.86;
    sheet.getRangeByName("D1").columnWidth = 12.86;
    sheet.getRangeByName("E1").columnWidth = 12.86;
  }

  void createCostumerInformationsTable(
    Worksheet sheet,
    Costumer costumer,
    Style style,
  ) {
    final List<Object> costumerInformationDataRows = buildCostumerInformationDataRows(costumer);

    final List<Object> costumerInformationDataRowsHeaders = [
      'Corporate Title',
      'Tax Number',
      'Tax Administration',
      'Address',
      'Phone Number',
      'E-mail',
    ];

    final List<Object> totalBalanceDataRows = [
      'Total Sales',
      'Total Payments',
      'Total Balance',
    ];

    sheet.importList(totalBalanceDataRows, 1, sheet.getLastColumn() + 2, true);

    final Range totalBalanceRange = sheet.getRangeByName("G1:H3");
    totalBalanceRange.cellStyle = style;

    final int column = sheet.getLastColumn() + 2;
    const int row = 1;
    const int lastRow = row + 5;
    final int lastColumn = column + 1;

    sheet.importList(costumerInformationDataRowsHeaders, row, column, true);
    sheet.importList(costumerInformationDataRows, row, lastColumn, true);

    final Range range = sheet.getRangeByIndex(row, column, lastRow, lastColumn);
    range.autoFitColumns();
    range.cellStyle = style;
  }

  void createExcelFromThisCostumer() async {
    final String? directoryPath = await getSavePath(suggestedName: currentCostumer!.corporateTitle);
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

    createTransactionsTable(sheet, globalStyle, headerStyle, currentCostumer!);
    createCostumerInformationsTable(
      sheet,
      currentCostumer!,
      informationStyle,
    );

    int transactionCount = currentCostumer!.transactions.length;

    sheet.getRangeByName("C2:E${transactionCount + 1}").numberFormat = '₺#,##0.0';

    sheet.getRangeByName('E2').setFormula('=C2-D2');

    for (int i = 3, last = transactionCount + 1; i <= last; i++) {
      sheet.getRangeByName('E$i').setFormula('=E${i - 1}+C$i-D$i');
    }

    sheet.getRangeByIndex(1, 1, sheet.getLastRow(), 1).rowHeight = 22;

    sheet.getRangeByName('H1').setFormula('=SUM(C2:C${transactionCount + 1})');
    sheet.getRangeByName('H2').setFormula('=SUM(D2:D${transactionCount + 1})');
    sheet.getRangeByName('H3').setFormula('=H1-H2');
    sheet.getRangeByName("H1:H3").numberFormat = '₺#,##0.0';

    sheet.getRangeByName('G1').columnWidth = 15;
    sheet.getRangeByName('H1').columnWidth = 13;

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    File('$directoryPath.xlsx').writeAsBytes(bytes);
  }

  void createExcelFromCostumers() async {
    final String? directoryPath = await getSavePath(suggestedName: "Costumers");
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

    bool isFirst = true;
    for (final Costumer costumer in _costumers) {
      if (costumer.isSelected) {
        final Worksheet sheet;
        if (isFirst) {
          sheet = workbook.worksheets[0];
          sheet.name = costumer.corporateTitle;
          isFirst = false;
        } else {
          sheet = workbook.worksheets.addWithName(costumer.corporateTitle);
        }

        createTransactionsTable(sheet, globalStyle, headerStyle, costumer);
        createCostumerInformationsTable(
          sheet,
          costumer,
          informationStyle,
        );

        int transactionCount = costumer.transactions.length;

        sheet.getRangeByName("C2:E${transactionCount + 1}").numberFormat = '₺#,##0.0';

        sheet.getRangeByName('E2').setFormula('=C2-D2');

        for (int i = 3, last = transactionCount + 1; i <= last; i++) {
          sheet.getRangeByName('E$i').setFormula('=E${i - 1}+C$i-D$i');
        }

        sheet.getRangeByIndex(1, 1, sheet.getLastRow(), 1).rowHeight = 22;

        sheet.getRangeByName('H1').setFormula('=SUM(C2:C${transactionCount + 1})');
        sheet.getRangeByName('H2').setFormula('=SUM(D2:D${transactionCount + 1})');
        sheet.getRangeByName('H3').setFormula('=H1-H2');
        sheet.getRangeByName("H1:H3").numberFormat = '₺#,##0.0';

        sheet.getRangeByName('G1').columnWidth = 15;
        sheet.getRangeByName('H1').columnWidth = 13;
      }

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      File('$directoryPath.xlsx').writeAsBytes(bytes);
    }
  }
}
