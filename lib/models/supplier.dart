import 'package:business_management/models/transaction.dart';
import 'package:business_management/models/transaction_type.dart';
import 'package:hive/hive.dart';

part 'supplier.g.dart';

@HiveType(typeId: 3)
class Supplier extends HiveObject {
  @HiveField(0)
  final String corporateTitle;

  @HiveField(1)
  final HiveList<Transaction> transactionsHiveList;

  List<Transaction> transactions = [];

  final transactionsBox = Hive.box<Transaction>("transactionsBox");

  @HiveField(2)
  double balance = 0;

  @HiveField(3)
  final int supplierIndex;

  @HiveField(4)
  final String taxNumber;

  @HiveField(5)
  final String taxAdministration;

  @HiveField(6)
  final String address;

  @HiveField(7)
  final String phoneNumber;

  @HiveField(8)
  final String email;

  @HiveField(9)
  final String creationDate;

  @HiveField(10)
  final String? lastModifiedDate;

  bool isSelected;

  List<Transaction> get reversedTransactions => List.from(transactions.reversed);

  void calculateBalance() {
    balance = 0;

    for (final Transaction transaction in transactions) {
      if (transaction.transactionType == TransactionType.suppliersPayment) {
        balance += transaction.totalPrice;
      } else {
        balance -= transaction.totalPrice;
      }
    }
  }

  Future<void> addTransaction(Transaction newTransaction) async {
    transactionsBox.add(newTransaction);
    transactionsHiveList.add(newTransaction);
    transactions = transactionsHiveList.toList();
    calculateBalance();
    await save();
  }

  Future<void> deleteTransaction(int index) async {
    for (final Transaction transaction in transactions) {
      if (transaction.isSelected) {
        transaction.delete();
      }
    }
    transactions = transactionsHiveList.toList();
    calculateBalance();
    await save();
  }

  Future<void> deleteSelectedTransactions() async {
    transactions.removeWhere((element) => element.isSelected == true);
    calculateBalance();
    await save();
  }

  Supplier({
    required this.supplierIndex,
    required this.corporateTitle,
    required this.taxNumber,
    required this.taxAdministration,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.creationDate,
    this.lastModifiedDate,
    required this.transactionsHiveList,
  }) : isSelected = false {
    transactions = transactionsHiveList.toList();
    calculateBalance();
  }
}
