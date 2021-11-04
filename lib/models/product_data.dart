import 'package:business_management/models/product.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class ProductsData extends ChangeNotifier {
  final Box<Product> _box = Hive.box<Product>("productsBox");

  List<Product> _products = [];

  Product? _activeProduct;

  void getProducts() {
    _products = _box.values.toList();
    notifyListeners();
  }

  Product getProduct(int index) {
    return _products[index];
  }

  int get productCount => _products.length;

  void addProduct(Product newProduct) async {
    _box.add(newProduct);

    _products = _box.values.toList();

    notifyListeners();
  }

  void deleteContact(key) async {
    await _box.delete(key);

    _products = _box.values.toList();

    notifyListeners();
  }

  void editContact({required Product product, required int productKey}) async {
    await _box.put(productKey, product);

    _products = _box.values.toList();

    _activeProduct = _box.get(productKey);

    notifyListeners();
  }

  void setActiveContact(int key) async {
    _activeProduct = _box.get(key);

    notifyListeners();
  }

  Product? get activeProduct => _activeProduct;
}
