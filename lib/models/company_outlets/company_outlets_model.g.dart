// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_outlets_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompanyOutletsModelAdapter extends TypeAdapter<CompanyOutletsModel> {
  @override
  final int typeId = 13;

  @override
  CompanyOutletsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompanyOutletsModel(
      id: fields[0] as int?,
      outletCode: fields[1] as String?,
      businessCode: fields[2] as String?,
      outletName: fields[3] as String?,
      createdAt: fields[4] as DateTime?,
      updatedAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CompanyOutletsModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.outletCode)
      ..writeByte(2)
      ..write(obj.businessCode)
      ..writeByte(3)
      ..write(obj.outletName)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompanyOutletsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
