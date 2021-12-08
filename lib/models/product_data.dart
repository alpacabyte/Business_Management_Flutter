import 'dart:convert';
import 'dart:io';

import 'package:business_management/functions/get_app_documents_dir.dart';
import 'package:business_management/models/product.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class ProductsData extends ChangeNotifier {
  final Box<Product> _box = Hive.box<Product>("productsBox");

  List<Product> _products = [];

  Product? _activeProduct;

  void getProducts() {
    _products = _box.values.toList();

    _products
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    notifyListeners();
  }

  Product getProduct(int index) {
    return _products[index];
  }

  int get productCount => _products.length;

  void deleteProduct(key) async {
    await _box.delete(key);

    _products = _box.values.toList();

    notifyListeners();
  }

  void deleteAllProducts() async {
    await _box.clear();

    _products = _box.values.toList();

    notifyListeners();
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
    await _box.put(
      _box.length,
      Product(
        name: name,
        image: image,
        productCode: productCode,
        moldCode: moldCode,
        printingWeight: printingWeight,
        unitWeight: numberOfCompartments != 0
            ? printingWeight / numberOfCompartments
            : printingWeight / 1,
        numberOfCompartments: numberOfCompartments,
        productionTime: productionTime,
        usedMaterial: usedMaterial,
        usedPaint: usedPaint,
        auxiliaryMaterial: auxiliaryMaterial,
        machineTonnage: machineTonnage,
        marketPrice: marketPrice,
        productIndex: _box.length,
        creationDate: DateFormat('yMd').format(DateTime.now()),
      ),
    );

    _products = _box.values.toList();

    notifyListeners();
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
        unitWeight: numberOfCompartments != 0
            ? printingWeight / numberOfCompartments
            : printingWeight / 1,
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

    _products = _box.values.toList();

    notifyListeners();
  }

  void setActiveProduct(key) async {
    _activeProduct = _box.get(key);

    notifyListeners();
  }

  Product? get activeProduct => _activeProduct;

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> list = _products.map((e) => e.toJson()).toList();
    return {"products": list};
  }

  Future<void> saveJson() async {
    final String timeNow =
        DateFormat("dd.MM.yyyy-HH.mm").format(DateTime.now());

    _products = _box.values.toList();

    final String path = await getAppDocDirFolder("Backups");

    final File file = File("$path/$timeNow.txt");

    file.writeAsString(json.encode(toJson()));
  }
}
