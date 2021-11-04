import 'package:business_management/functions/get_app_documents_dir.dart';
import 'package:business_management/models/product.dart';
import 'package:hive/hive.dart';

Future<void> initHive() async {
  final String hivePath = await getAppDocDirFolder("Hive");

  Hive.init(hivePath);

  Hive.registerAdapter(ProductAdapter());

  await Hive.openBox<Product>("productsBox");
}
