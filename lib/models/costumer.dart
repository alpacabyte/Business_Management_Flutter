import 'package:business_management/models/transaction.dart';
import 'package:hive/hive.dart';

part 'costumer.g.dart';

@HiveType(typeId: 1)
class Costumer extends HiveObject {
  @HiveField(0)
  final String corporateTitle;

  @HiveField(1)
  final List<Transaction> transactions;

  @HiveField(2)
  double balance = 0;

  @HiveField(3)
  final int costumerIndex;

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

  void calculateBalance() {
    balance = 0;

    for (final Transaction transaction in transactions) {
      if (transaction.isSale) {
        balance += transaction.totalPrice;
      } else {
        balance -= transaction.totalPrice;
      }
    }
  }

  Future<void> addTransaction(Transaction newTransaction) async {
    transactions.add(newTransaction);
    calculateBalance();
    await save();
  }

  Future<void> deleteTransaction(int index) async {
    transactions.removeAt(index);
    calculateBalance();
    await save();
  }

  Costumer({
    required this.costumerIndex,
    required this.corporateTitle,
    required this.taxNumber,
    required this.taxAdministration,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.creationDate,
    this.lastModifiedDate,
    this.transactions = const [],
  }) {
    calculateBalance();
  }
}
