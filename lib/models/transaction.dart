import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 2)
class Transaction extends HiveObject {
  @HiveField(0)
  final String comment;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  final double unitPrice;

  @HiveField(4)
  final bool isPayment;

  @HiveField(5)
  final String transactionDate;

  @HiveField(6)
  final double totalPrice;

  bool isSelected;

  Transaction({
    required this.comment,
    required this.transactionDate,
    required this.unitPrice,
    required this.isPayment,
    this.quantity = 1,
  })  : totalPrice = quantity * unitPrice,
        isSelected = false;
}
