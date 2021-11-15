import 'package:business_management/models/costumer.dart';
import 'package:business_management/models/transaction.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class CostumersData extends ChangeNotifier {
  final Box<Costumer> _costumerBox = Hive.box<Costumer>("costumersBox");

  List<Costumer> _costumers = [];

  Costumer? _currentCostumer;

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
      ),
    );

    _costumers = _costumerBox.values.toList();

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

  Future<void> addTransactionToCostumer(Transaction newTransaction) async {
    if (_currentCostumer != null) {
      await _currentCostumer!.addTransaction(newTransaction);
    }
  }

  Future<void> deleteTransactionFromCostumer() async {}

  Costumer? get currentCostumer => _currentCostumer;

  void setCurrentCostumer(key) async {
    _currentCostumer = _costumerBox.get(key);

    notifyListeners();
  }
}
