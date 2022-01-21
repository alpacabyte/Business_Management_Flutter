import 'dart:convert';
import 'dart:io';
import 'package:business_management/functions/get_app_documents_dir.dart';
import 'package:business_management/main.dart';
import 'package:business_management/models/product.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ProductsData extends ChangeNotifier {
  final Box<Product> _box = Hive.box<Product>("productsBox");

  List<Product> _products = [];

  Product? _activeProduct;

  void getProducts() {
    _products = _box.values.toList();

    _products.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    notifyListeners();
  }

  ProductsData() {
    _products = _box.values.toList();

    _products.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  List<Product> get products => _products;

  Product getProduct(int index) {
    return _products[index];
  }

  void setIsSelectedOfAllProducts(bool? value) {
    if (value == null) return;

    for (Product product in _products) {
      product.isSelected = value;
    }
  }

  int get productCount => _products.length;

  void deleteProduct(key) async {
    await _box.delete(key);

    getProducts();
  }

  Future<void> deleteSelectedProducts() async {
    for (Product product in _products) {
      if (product.isSelected) {
        _box.delete(product.productIndex);
      }
    }

    getProducts();
  }

  void deleteAllProducts() async {
    await _box.clear();

    getProducts();
  }

  Future<void> addProduct({
    required String name,
    required String? image,
    required String productCode,
    required String moldCode,
    required double printingWeight,
    required int numberOfCompartments,
    required double productionTime,
    required String usedMaterial,
    required String usedPaint,
    required String auxiliaryMaterial,
    required double machineTonnage,
    required double marketPrice,
  }) async {
    int productIndex = 0;

    for (final Product product in products) {
      if (product.productIndex > productIndex) {
        productIndex = product.productIndex;
      }
    }

    productIndex++;

    await _box.put(
      productIndex,
      Product(
        name: name,
        image: image,
        productCode: productCode,
        moldCode: moldCode,
        printingWeight: printingWeight,
        unitWeight: numberOfCompartments != 0 ? printingWeight / numberOfCompartments : printingWeight / 1,
        numberOfCompartments: numberOfCompartments,
        productionTime: productionTime,
        usedMaterial: usedMaterial,
        usedPaint: usedPaint,
        auxiliaryMaterial: auxiliaryMaterial,
        machineTonnage: machineTonnage,
        marketPrice: marketPrice,
        productIndex: productIndex,
        creationDate: DateFormat('yMd').format(DateTime.now()),
      ),
    );

    getProducts();
  }

  Future<void> editProduct({
    required String name,
    required String? image,
    required String productCode,
    required String moldCode,
    required double printingWeight,
    required int numberOfCompartments,
    required double productionTime,
    required String usedMaterial,
    required String usedPaint,
    required String auxiliaryMaterial,
    required double machineTonnage,
    required double marketPrice,
    required int productIndex,
    required String creationDate,
  }) async {
    await _box.put(
      productIndex,
      Product(
        name: name,
        image: image,
        productCode: productCode,
        moldCode: moldCode,
        printingWeight: printingWeight,
        unitWeight: numberOfCompartments != 0 ? printingWeight / numberOfCompartments : printingWeight / 1,
        numberOfCompartments: numberOfCompartments,
        productionTime: productionTime,
        usedMaterial: usedMaterial,
        usedPaint: usedPaint,
        auxiliaryMaterial: auxiliaryMaterial,
        machineTonnage: machineTonnage,
        marketPrice: marketPrice,
        productIndex: productIndex,
        lastModifiedDate: DateFormat('yMd').format(DateTime.now()),
        creationDate: creationDate,
      ),
    );

    _activeProduct = _box.get(productIndex);

    getProducts();
  }

  void setActiveProduct(key) async {
    _activeProduct = _box.get(key);

    notifyListeners();
  }

  Product? get activeProduct => _activeProduct;

  List<Map<String, dynamic>> productsAsMap() {
    _products = _box.values.toList();
    _products.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    final List<Map<String, dynamic>> list = _products.map((e) => e.toJson()).toList();
    return list;
  }

  Future<void> saveJson() async {
    final String timeNow = DateFormat("dd.MM.yyyy-HH.mm").format(DateTime.now());

    final String path = await getAppDocDirFolder("Backups");

    final File file = File("$path/$timeNow.txt");

    final String productsJSON = json.encode({"products": productsAsMap()});

    file.writeAsString(productsJSON);
  }

  List<ExcelDataRow> buildProductDataRows(BuildContext context) {
    final List<ExcelDataRow> excelDataRows = _products
        .map((product) => ExcelDataRow(cells: <ExcelDataCell>[
              ExcelDataCell(
                columnHeader: '#',
                value: product.productIndex,
              ),
              ExcelDataCell(
                columnHeader: appLocalization(context).productName,
                value: product.name,
              ),
              ExcelDataCell(
                columnHeader: appLocalization(context).productCode,
                value: product.productCode,
              ),
              ExcelDataCell(
                columnHeader: appLocalization(context).moldCode,
                value: product.moldCode,
              ),
              ExcelDataCell(
                columnHeader: appLocalization(context).printingWeight,
                value: product.printingWeight,
              ),
              ExcelDataCell(
                columnHeader: appLocalization(context).unitWeight,
                value: null,
              ),
              ExcelDataCell(
                columnHeader: appLocalization(context).numberOfCompartments,
                value: product.numberOfCompartments,
              ),
              ExcelDataCell(
                columnHeader: appLocalization(context).productionTime,
                value: product.productionTime,
              ),
              ExcelDataCell(
                columnHeader: appLocalization(context).usedMaterial,
                value: product.usedMaterial,
              ),
              ExcelDataCell(
                columnHeader: appLocalization(context).usedPaint,
                value: product.usedPaint,
              ),
              ExcelDataCell(
                columnHeader: appLocalization(context).auxiliaryMaterial,
                value: product.auxiliaryMaterial,
              ),
              ExcelDataCell(
                columnHeader: appLocalization(context).machineTonnage,
                value: product.machineTonnage,
              ),
              ExcelDataCell(
                columnHeader: '${appLocalization(context).marketPrice} (TL)',
                value: product.marketPrice,
              ),
            ]))
        .toList();

    return excelDataRows;
  }

  void createExcelFromProducts(BuildContext context) async {
    final String? directoryPath = await getSavePath(suggestedName: "Product Chart");
    if (directoryPath == null || _products.isEmpty) return;

    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    final List<ExcelDataRow> dataRows = buildProductDataRows(context);

    sheet.importData(dataRows, 1, 1);

    final int lastColumn = sheet.getLastColumn();
    final int lastRow = sheet.getLastRow();
    final Range range = sheet.getRangeByIndex(1, 1, lastRow, lastColumn);

    range.autoFitColumns();
    range.rowHeight = 25;

    final Style globalStyle = workbook.styles.add('globalStyle');
    globalStyle.hAlign = HAlignType.center;
    globalStyle.vAlign = VAlignType.center;
    globalStyle.backColor = "#D9E1F2";
    globalStyle.borders.all.lineStyle = LineStyle.thin;

    range.cellStyle = globalStyle;

    final Range rangeHeaders = sheet.getRangeByIndex(1, 1, 1, lastColumn);

    final Style headerStyle = workbook.styles.add('headerStyle');
    headerStyle.hAlign = HAlignType.center;
    headerStyle.vAlign = VAlignType.center;
    headerStyle.backColor = "#FCE4D6";
    headerStyle.borders.top.lineStyle = LineStyle.thin;
    headerStyle.borders.bottom.lineStyle = LineStyle.double;
    headerStyle.borders.right.lineStyle = LineStyle.thin;
    headerStyle.borders.left.lineStyle = LineStyle.thin;

    rangeHeaders.cellStyle = headerStyle;

    sheet.enableSheetCalculations();

    for (int i = 2, last = sheet.getLastRow(); i <= last; i++) {
      sheet.getRangeByName('F$i').setFormula('=E$i/G$i');
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    File('$directoryPath.xlsx').writeAsBytes(bytes);
  }
}
