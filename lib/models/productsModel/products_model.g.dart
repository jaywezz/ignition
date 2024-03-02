// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductsModelAdapter extends TypeAdapter<ProductsModel> {
  @override
  final int typeId = 16;

  @override
  ProductsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductsModel(
      region: fields[0] as int?,
      productId: fields[1] as int?,
      date: fields[2] as DateTime?,
      wholesalePrice: fields[3] as String?,
      retailPrice: fields[4] as String?,
      productName: fields[5] as String?,
      stock: fields[6] as int?,
      businessCode: fields[7] as String?,
      skuCode: fields[8] as String?,
      brand: fields[9] as String?,
      category: fields[10] as String?,
      distributorPrice: fields[11] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductsModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.region)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.wholesalePrice)
      ..writeByte(4)
      ..write(obj.retailPrice)
      ..writeByte(5)
      ..write(obj.productName)
      ..writeByte(6)
      ..write(obj.stock)
      ..writeByte(7)
      ..write(obj.businessCode)
      ..writeByte(8)
      ..write(obj.skuCode)
      ..writeByte(9)
      ..write(obj.brand)
      ..writeByte(10)
      ..write(obj.category)
      ..writeByte(11)
      ..write(obj.distributorPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
