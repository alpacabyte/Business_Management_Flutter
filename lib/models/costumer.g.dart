// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'costumer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CostumerAdapter extends TypeAdapter<Costumer> {
  @override
  final int typeId = 1;

  @override
  Costumer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Costumer(
      costumerIndex: fields[3] as int,
      corporateTitle: fields[0] as String,
      taxNumber: fields[4] as String,
      taxAdministration: fields[5] as String,
      address: fields[6] as String,
      phoneNumber: fields[7] as String,
      email: fields[8] as String,
      creationDate: fields[9] as String,
      transactions: (fields[1] as List).cast<Transaction>(),
      lastModifiedDate: fields[10] as String?,
    )..balance = fields[2] as double;
  }

  @override
  void write(BinaryWriter writer, Costumer obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.corporateTitle)
      ..writeByte(1)
      ..write(obj.transactions)
      ..writeByte(2)
      ..write(obj.balance)
      ..writeByte(3)
      ..write(obj.costumerIndex)
      ..writeByte(4)
      ..write(obj.taxNumber)
      ..writeByte(5)
      ..write(obj.taxAdministration)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.phoneNumber)
      ..writeByte(8)
      ..write(obj.email)
      ..writeByte(9)
      ..write(obj.creationDate)
      ..writeByte(10)
      ..write(obj.lastModifiedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CostumerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
