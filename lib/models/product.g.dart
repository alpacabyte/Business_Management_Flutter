// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 0;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      name: fields[0] as String,
      image: fields[1] as String?,
      productCode: fields[2] as String,
      moldCode: fields[3] as String,
      printingWeight: fields[4] as double,
      unitWeight: fields[5] as double,
      numberOfCompartments: fields[6] as int,
      productionTime: fields[7] as double,
      usedMaterial: fields[8] as String,
      usedPaint: fields[9] as String,
      auxiliaryMaterial: fields[10] as String,
      machineTonnage: fields[11] as double,
      marketPrice: fields[12] as double,
      productIndex: fields[13] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.productCode)
      ..writeByte(3)
      ..write(obj.moldCode)
      ..writeByte(4)
      ..write(obj.printingWeight)
      ..writeByte(5)
      ..write(obj.unitWeight)
      ..writeByte(6)
      ..write(obj.numberOfCompartments)
      ..writeByte(7)
      ..write(obj.productionTime)
      ..writeByte(8)
      ..write(obj.usedMaterial)
      ..writeByte(9)
      ..write(obj.usedPaint)
      ..writeByte(10)
      ..write(obj.auxiliaryMaterial)
      ..writeByte(11)
      ..write(obj.machineTonnage)
      ..writeByte(12)
      ..write(obj.marketPrice)
      ..writeByte(13)
      ..write(obj.productIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
