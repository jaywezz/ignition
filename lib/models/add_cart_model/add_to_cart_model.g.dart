// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_to_cart_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewSalesCartAdapter extends TypeAdapter<NewSalesCart> {
  @override
  final int typeId = 10;

  @override
  NewSalesCart read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NewSalesCart(
      productMo: fields[0] as ProductsModel?,
      qty: fields[1] as int?,
      price: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NewSalesCart obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.productMo)
      ..writeByte(1)
      ..write(obj.qty)
      ..writeByte(2)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewSalesCartAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VanSalesCartAdapter extends TypeAdapter<VanSalesCart> {
  @override
  final int typeId = 9;

  @override
  VanSalesCart read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VanSalesCart(
      latestAllocationModel: fields[0] as LatestAllocationModel?,
      qty: fields[1] as int?,
      price: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, VanSalesCart obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.latestAllocationModel)
      ..writeByte(1)
      ..write(obj.qty)
      ..writeByte(2)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VanSalesCartAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReconcileCartAdapter extends TypeAdapter<ReconcileCart> {
  @override
  final int typeId = 9;

  @override
  ReconcileCart read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReconcileCart(
      latestAllocationModel: fields[0] as LatestAllocationModel?,
      qty: fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ReconcileCart obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.latestAllocationModel)
      ..writeByte(1)
      ..write(obj.qty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReconcileCartAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
