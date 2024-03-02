// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_count.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SalesCountClassAdapter extends TypeAdapter<_$_SalesCount> {
  @override
  final int typeId = 7;

  @override
  _$_SalesCount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$_SalesCount(
      TotalSales: fields[0] as int?,
      message: fields[1] as String?,
      success: fields[2] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, _$_SalesCount obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.TotalSales)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.success);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesCountClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SalesCount _$$_SalesCountFromJson(Map<String, dynamic> json) =>
    _$_SalesCount(
      TotalSales: json['TotalSales'] as int?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$$_SalesCountToJson(_$_SalesCount instance) =>
    <String, dynamic>{
      'TotalSales': instance.TotalSales,
      'message': instance.message,
      'success': instance.success,
    };
