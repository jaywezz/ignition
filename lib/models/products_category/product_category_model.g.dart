// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_category_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductCategoryModelAdapter extends TypeAdapter<ProductCategoryModel> {
  @override
  final int typeId = 2;

  @override
  ProductCategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductCategoryModel(
      id: fields[0] as int?,
      name: fields[1] as String?,
      parentId: fields[2] as String?,
      url: fields[3] as String?,
      businessCode: fields[4] as String?,
      createdBy: fields[5] as int?,
      updatedBy: fields[6] as int?,
      createdAt: fields[7] as String?,
      updatedAt: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductCategoryModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.parentId)
      ..writeByte(3)
      ..write(obj.url)
      ..writeByte(4)
      ..write(obj.businessCode)
      ..writeByte(5)
      ..write(obj.createdBy)
      ..writeByte(6)
      ..write(obj.updatedBy)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductCategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
