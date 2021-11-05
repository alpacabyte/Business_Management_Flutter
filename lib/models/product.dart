import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0) // use Hive to generate a type adapter
class Product extends HiveObject {
  // Define variables

  @HiveField(0)
  final String name;

  @HiveField(1)
  final String? image;

  @HiveField(2)
  final String productCode;

  @HiveField(3)
  final String moldCode;

  @HiveField(4)
  final double printingWeight;

  @HiveField(5)
  final double unitWeight;

  @HiveField(6)
  final int numberOfCompartments;

  @HiveField(7)
  final double productionTime;

  @HiveField(8)
  final String usedMaterial;

  @HiveField(9)
  final String usedPaint;

  @HiveField(10)
  final String auxiliaryMaterial;

  @HiveField(11)
  final double machineTonnage;

  @HiveField(12)
  final double marketPrice;

  @HiveField(13)
  final int productIndex;

  // Constructor
  Product({
    required this.name,
    required this.image,
    required this.productCode,
    required this.moldCode,
    required this.printingWeight,
    required this.unitWeight,
    required this.numberOfCompartments,
    required this.productionTime,
    required this.usedMaterial,
    required this.usedPaint,
    required this.auxiliaryMaterial,
    required this.machineTonnage,
    required this.marketPrice,
    required this.productIndex,
  });
}
