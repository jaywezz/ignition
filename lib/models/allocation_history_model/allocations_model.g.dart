// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocations_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AllocationHistoryModelAdapter
    extends TypeAdapter<AllocationHistoryModel> {
  @override
  final int typeId = 4;

  @override
  AllocationHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AllocationHistoryModel(
      productName: fields[0] as String?,
      brand: fields[1] as String?,
      allocationCode: fields[2] as String?,
      sellingPrice: fields[4] as String?,
      buyingPrice: fields[3] as String?,
      currentQty: fields[6] as int?,
      skuCode: fields[5] as String?,
      allocatedQty: fields[7] as String?,
      createdAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AllocationHistoryModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.productName)
      ..writeByte(1)
      ..write(obj.brand)
      ..writeByte(2)
      ..write(obj.allocationCode)
      ..writeByte(3)
      ..write(obj.buyingPrice)
      ..writeByte(4)
      ..write(obj.sellingPrice)
      ..writeByte(5)
      ..write(obj.skuCode)
      ..writeByte(6)
      ..write(obj.currentQty)
      ..writeByte(7)
      ..write(obj.allocatedQty)
      ..writeByte(8)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllocationHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
