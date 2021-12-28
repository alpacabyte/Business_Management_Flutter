// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
  @override
  final int typeId = 4;

  @override
  TransactionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionType.costumersSale;
      case 1:
        return TransactionType.costumersPayment;
      case 2:
        return TransactionType.suppliersPayment;
      case 3:
        return TransactionType.suppliersPurchase;
      default:
        return TransactionType.costumersSale;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionType obj) {
    switch (obj) {
      case TransactionType.costumersSale:
        writer.writeByte(0);
        break;
      case TransactionType.costumersPayment:
        writer.writeByte(1);
        break;
      case TransactionType.suppliersPayment:
        writer.writeByte(2);
        break;
      case TransactionType.suppliersPurchase:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
