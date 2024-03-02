// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latest_allocated_items_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LatestAllocationModelAdapter extends TypeAdapter<LatestAllocationModel> {
  @override
  final int typeId = 3;

  @override
  LatestAllocationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LatestAllocationModel(
      id: fields[0] as int?,
      productName: fields[1] as String?,
      brand: fields[2] as String?,
      allocationCode: fields[4] as String?,
      category: fields[3] as String?,
      retailPrice: fields[5] as String?,
      wholeSalePrice: fields[6] as String?,
      distributorPrice: fields[11] as String?,
      currentQty: fields[8] as int?,
      skuCode: fields[7] as String?,
      allocatedQty: fields[9] as String?,
      createdAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, LatestAllocationModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.brand)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.allocationCode)
      ..writeByte(5)
      ..write(obj.retailPrice)
      ..writeByte(6)
      ..write(obj.wholeSalePrice)
      ..writeByte(7)
      ..write(obj.skuCode)
      ..writeByte(8)
      ..write(obj.currentQty)
      ..writeByte(9)
      ..write(obj.allocatedQty)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.distributorPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatestAllocationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
