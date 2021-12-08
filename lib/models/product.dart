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

  @HiveField(14)
  final String creationDate;

  @HiveField(15)
  final String? lastModifiedDate;

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
    required this.creationDate,
    this.lastModifiedDate = "-",
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['Image Folder'] = image;
    data['Product Code'] = productCode;
    data['Mold Code'] = moldCode;
    data['Printing Weight'] = printingWeight;
    data['Unit Weight'] = unitWeight;
    data['Number Of Compartments'] = numberOfCompartments;
    data['Production Time'] = productionTime;
    data['Used Material'] = usedMaterial;
    data['Used Paint'] = usedPaint;
    data['Auxiliary Material'] = auxiliaryMaterial;
    data['Machine Tonnage'] = machineTonnage;
    data['Market Price'] = marketPrice;
    data['Product Index'] = productIndex;
    data['Creation Date'] = creationDate;
    data['Last Modified Date'] = lastModifiedDate;
    return data;
  }
}
