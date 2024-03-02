// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_count.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisitCountClassAdapter extends TypeAdapter<_$_VisitsCount> {
  @override
  final int typeId = 8;

  @override
  _$_VisitsCount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$_VisitsCount(
      TotalVisitsPerThisWeek: fields[0] as int,
      TotalVisitsPerThisMonth: fields[1] as int,
      TotalVisitsThisYear: fields[2] as int,
      message: fields[3] as String,
      success: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, _$_VisitsCount obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.TotalVisitsPerThisWeek)
      ..writeByte(1)
      ..write(obj.TotalVisitsPerThisMonth)
      ..writeByte(2)
      ..write(obj.TotalVisitsThisYear)
      ..writeByte(3)
      ..write(obj.message)
      ..writeByte(4)
      ..write(obj.success);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisitCountClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_VisitsCount _$$_VisitsCountFromJson(Map<String, dynamic> json) =>
    _$_VisitsCount(
      TotalVisitsPerThisWeek: json['TotalVisitsPerThisWeek'] as int,
      TotalVisitsPerThisMonth: json['TotalVisitsPerThisMonth'] as int,
      TotalVisitsThisYear: json['TotalVisitsThisYear'] as int,
      message: json['message'] as String,
      success: json['success'] as bool,
    );

Map<String, dynamic> _$$_VisitsCountToJson(_$_VisitsCount instance) =>
    <String, dynamic>{
      'TotalVisitsPerThisWeek': instance.TotalVisitsPerThisWeek,
      'TotalVisitsPerThisMonth': instance.TotalVisitsPerThisMonth,
      'TotalVisitsThisYear': instance.TotalVisitsThisYear,
      'message': instance.message,
      'success': instance.success,
    };
