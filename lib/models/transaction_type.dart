import 'package:hive/hive.dart';

part 'transaction_type.g.dart';

@HiveType(typeId: 4)
enum TransactionType {
  @HiveField(0)
  costumersSale,

  @HiveField(1)
  costumersPayment,

  @HiveField(2)
  suppliersPayment,

  @HiveField(3)
  suppliersPurchase,
}
