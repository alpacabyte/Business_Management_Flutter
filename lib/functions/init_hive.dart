import 'package:business_management/functions/get_app_documents_dir.dart';
import 'package:business_management/models/costumer.dart';
import 'package:business_management/models/product.dart';
import 'package:business_management/models/supplier.dart';
import 'package:business_management/models/transaction.dart';
import 'package:hive/hive.dart';

Future<void> initHive() async {
  final String hivePath = await getAppDocDirFolder("Hive");

  Hive.init(hivePath);

  Hive
    ..registerAdapter(ProductAdapter())
    ..registerAdapter(CostumerAdapter())
    ..registerAdapter(TransactionAdapter())
    ..registerAdapter(SupplierAdapter());

  await Hive.openBox<Product>("productsBox");

  await Hive.openBox<Supplier>("suppliersBox");

  await Hive.openBox<Costumer>("costumersBox");
}
