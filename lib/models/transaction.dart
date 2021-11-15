import 'package:business_management/models/product.dart';
import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 2)
class Transaction extends HiveObject {
  @HiveField(0)
  final String comment;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  final double unitPrice;

  @HiveField(4)
  final bool isSale;

  @HiveField(5)
  final String transactionDate;

  @HiveField(6)
  final double totalPrice;

  Transaction({
    required this.comment,
    required this.quantity,
    required this.transactionDate,
    required this.productName,
    required this.unitPrice,
  })  : isSale = true,
        totalPrice = quantity * unitPrice;

  Transaction.saleWithProduct({
    required this.comment,
    required this.quantity,
    required this.transactionDate,
    required Product product,
  })  : isSale = true,
        productName = product.name,
        unitPrice = product.marketPrice,
        totalPrice = quantity * product.marketPrice;

  Transaction.sale({
    required this.comment,
    required this.quantity,
    required this.transactionDate,
    required this.productName,
    required this.unitPrice,
  })  : isSale = true,
        totalPrice = quantity * unitPrice;

  Transaction.payment({
    required this.comment,
    required this.transactionDate,
    required this.productName,
    required this.unitPrice,
  })  : isSale = false,
        quantity = 1,
        totalPrice = unitPrice;
}
