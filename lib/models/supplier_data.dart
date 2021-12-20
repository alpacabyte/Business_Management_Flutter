import 'dart:io';
import 'package:business_management/models/supplier.dart';
import 'package:business_management/models/transaction.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class SuppliersData extends ChangeNotifier {
  final Box<Supplier> _suppliersBox = Hive.box<Supplier>("suppliersBox");

  List<Supplier> _suppliers = [];

  Supplier? _currentSupplier;

  SuppliersData() {
    _suppliers = _suppliersBox.values.toList();
  }

  void getSuppliersList() async {
    _suppliers = _suppliersBox.values.toList();

    notifyListeners();
  }

  Supplier getSupplier(int key) => _suppliers[key];

  int get supplierCount => _suppliers.length;

  Future<void> deleteSupplier(key) async {
    await _suppliersBox.delete(key);

    _suppliers = _suppliersBox.values.toList();

    notifyListeners();
  }

  Future<void> deleteAllSuppliers() async {
    await _suppliersBox.clear();

    _suppliers = _suppliersBox.values.toList();

    notifyListeners();
  }

  Future<void> addSupplier({
    required String corporateTitle,
    required String taxNumber,
    required String taxAdministration,
    required String address,
    required String phoneNumber,
    required String email,
  }) async {
    int supplierIndex = 0;

    for (final Supplier supplier in _suppliers) {
      if (supplier.supplierIndex > supplierIndex) {
        supplierIndex = supplier.supplierIndex;
      }
    }

    supplierIndex++;

    await _suppliersBox.put(
      _suppliersBox.length,
      Supplier(
        supplierIndex: _suppliersBox.length,
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

    _suppliers = _suppliersBox.values.toList();

    notifyListeners();
  }

  void setIsSelectedOfSuppliers(bool? value) {
    if (value == null) return;

    for (Supplier supplier in _suppliers) {
      supplier.isSelected = value;
    }
  }

  void setIsSelectedOfAllTransactions(bool? value) {
    if (value == null) return;

    for (Transaction transaction in currentSupplier!.transactions) {
      transaction.isSelected = value;
    }
  }

  Future<void> deleteSelectedSuppliers() async {
    for (Supplier supplier in _suppliers) {
      if (supplier.isSelected) {
        _suppliersBox.delete(supplier.supplierIndex);
      }
    }

    _suppliers = _suppliersBox.values.toList();

    notifyListeners();
  }

  Future<void> addTransactionToCurrentSuppliers(Transaction newTransaction) async {
    await currentSupplier!.addTransaction(newTransaction);
    notifyListeners();
  }

  Future<void> editSupplier({
    required String corporateTitle,
    required String taxNumber,
    required String taxAdministration,
    required String address,
    required String phoneNumber,
    required String email,
    required int supplierIndex,
    required String creationDate,
    required List<Transaction> transactions,
  }) async {
    await _suppliersBox.put(
      supplierIndex,
      Supplier(
        supplierIndex: supplierIndex,
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

    _currentSupplier = _suppliersBox.get(supplierIndex);

    _suppliers = _suppliersBox.values.toList();

    notifyListeners();
  }

  Future<void> deleteTransactionFromCurrentSupplier(int index) async {
    await currentSupplier!.deleteTransaction(index);
    notifyListeners();
  }

  Future<void> deleteSelectedTransactionsFromCurrentSupplier() async {
    await currentSupplier!.deleteSelectedTransactions();
    notifyListeners();
  }

  Supplier? get currentSupplier => _currentSupplier;

  void setCurrentSupplier(key) async {
    _currentSupplier = _suppliersBox.get(key);

    notifyListeners();
  }

  List<ExcelDataRow> buildTransactionDataRows(Supplier supplier) {
    List<ExcelDataRow> excelDataRows = supplier.transactions
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
                columnHeader: 'Purchase',
                value: !transaction.isPayment ? transaction.totalPrice : null,
              ),
              ExcelDataCell(
                columnHeader: 'Payment',
                value: transaction.isPayment ? transaction.totalPrice : null,
              ),
              const ExcelDataCell(
                columnHeader: 'Balance',
                value: null,
              ),
            ]))
        .toList();

    return excelDataRows;
  }

  List<Object> buildSupplierInformationDataRows(Supplier supplier) {
    final List<Object> list = [
      supplier.corporateTitle,
      supplier.taxNumber,
      supplier.taxAdministration,
      supplier.address,
      supplier.phoneNumber,
      supplier.email,
    ];

    return list;
  }

  void createTransactionsTable(
    Worksheet sheet,
    Style globalStyle,
    Style headerStyle,
    Supplier supplier,
  ) {
    final List<ExcelDataRow> transactionsDataRows = buildTransactionDataRows(supplier);

    sheet.importData(transactionsDataRows, 1, 1);

    final int lastColumn = sheet.getLastColumn();
    final int lastRow = sheet.getLastRow();
    final Range range = sheet.getRangeByIndex(1, 1, lastRow, lastColumn);

    range.cellStyle = globalStyle;

    final Range rangeHeaders = sheet.getRangeByIndex(1, 1, 1, lastColumn);

    rangeHeaders.cellStyle = headerStyle;
  }

  void createSupplierInformationsTable(
    Worksheet sheet,
    Supplier supplier,
    Style style,
  ) {
    final List<Object> supplierInformationDataRows = buildSupplierInformationDataRows(supplier);

    final List<Object> eupplierInformationDataRowsHeaders = [
      'Corporate Title',
      'Tax Number',
      'Tax Administration',
      'Address',
      'Phone Number',
      'E-mail',
    ];

    final List<Object> totalBalanceDataRows = [
      'Total Purchases',
      'Total Payments',
      'Total Balance',
    ];

    sheet.importList(totalBalanceDataRows, 1, 7, true);

    final Range totalBalanceRange = sheet.getRangeByName("G1:H3");
    totalBalanceRange.cellStyle = style;

    sheet.importList(eupplierInformationDataRowsHeaders, 1, 10, true);
    sheet.importList(supplierInformationDataRows, 1, 11, true);

    final Range range = sheet.getRangeByName("J1:K6");
    range.autoFitColumns();
    range.cellStyle = style;
  }

  void createExcelFromThisSupplier() async {
    final String? directoryPath = await getSavePath(suggestedName: currentSupplier!.corporateTitle);
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

    if (currentSupplier!.transactions.isNotEmpty) {
      createTransactionsTable(sheet, globalStyle, headerStyle, currentSupplier!);
      sheet.getRangeByName('E2').setFormula('=D2-C2');
    }

    createSupplierInformationsTable(
      sheet,
      currentSupplier!,
      informationStyle,
    );

    int transactionCount = currentSupplier!.transactions.length;

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

  void createExcelFromSuppliers() async {
    final String? directoryPath = await getSavePath(suggestedName: "Suppliers");
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
    for (final Supplier supplier in _suppliers) {
      if (supplier.isSelected) {
        final Worksheet sheet;
        if (isFirst) {
          sheet = workbook.worksheets[0];
          sheet.name = supplier.corporateTitle;
          isFirst = false;
        } else {
          sheet = workbook.worksheets.addWithName(supplier.corporateTitle);
        }

        if (supplier.transactions.isNotEmpty) {
          createTransactionsTable(sheet, globalStyle, headerStyle, supplier);
          sheet.getRangeByName('E2').setFormula('=D2-C2');
        }

        createSupplierInformationsTable(
          sheet,
          supplier,
          informationStyle,
        );

        int transactionCount = supplier.transactions.length;

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
      }
    }
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    File('$directoryPath.xlsx').writeAsBytes(bytes);
  }
}