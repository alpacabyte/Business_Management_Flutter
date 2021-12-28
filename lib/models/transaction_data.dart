import 'package:business_management/models/transaction.dart';
import 'package:business_management/models/transaction_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TransactionsData extends ChangeNotifier {
  final transactionsBox = Hive.box<Transaction>("transactionsBox");

  Map<int, List<Transaction>> transactionsByMonths = {0: [], 1: [], 2: [], 3: [], 4: [], 5: [], 6: [], 7: [], 8: [], 9: [], 10: [], 11: []};
  Map<int, double> balanceByMonths = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0, 10: 0, 11: 0};

  List<Transaction> allPaymentTransactions = [];

  double balance = 0;

  void getTransactionsList() async {
    allPaymentTransactions = [];
    transactionsByMonths = {0: [], 1: [], 2: [], 3: [], 4: [], 5: [], 6: [], 7: [], 8: [], 9: [], 10: [], 11: []};

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
        getTransactionsList();
        notifyListeners();
      }
    }
  }

  void addTransactionToList(Transaction transaction) async {
    await transactionsBox.add(transaction);

    getTransactionsList();
  }

  void deleteAllSelectedTransactions() async {
    for (final Transaction transaction in allPaymentTransactions) {
      if (transaction.isSelected) {
        await transaction.delete();
        getTransactionsList();
        notifyListeners();
      }
    }
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
}
