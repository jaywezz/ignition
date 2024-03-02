// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_routes_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubregionAdapter extends TypeAdapter<Subregion> {
  @override
  final int typeId = 14;

  @override
  Subregion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subregion(
      id: fields[0] as int?,
      regionId: fields[1] as int?,
      name: fields[2] as String?,
      primaryKey: fields[3] as String?,
      createdAt: fields[4] as DateTime?,
      updatedAt: fields[5] as DateTime?,
      area: (fields[6] as List?)?.cast<RegionalRoutes>(),
    );
  }

  @override
  void write(BinaryWriter writer, Subregion obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.regionId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.primaryKey)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.area);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubregionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RegionalRoutesAdapter extends TypeAdapter<RegionalRoutes> {
  @override
  final int typeId = 15;

  @override
  RegionalRoutes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RegionalRoutes(
      id: fields[0] as int?,
      name: fields[1] as String?,
      primaryKey: fields[2] as String?,
      createdAt: fields[3] as DateTime?,
      updatedAt: fields[4] as DateTime?,
      subregion: (fields[5] as List?)?.cast<Subregion>(),
      subregionId: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, RegionalRoutes obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.primaryKey)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.subregion)
      ..writeByte(6)
      ..write(obj.subregionId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegionalRoutesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
